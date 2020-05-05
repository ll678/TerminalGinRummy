(** This code was inspired by the adventure game we created in A2 and A3 *)

let rec print_list lst =
  match lst with
  | [] -> ()
  | h::t -> print_string h; 
    print_string " "; 
    print_list t

let rec print_cards_top lst =
  match lst with
  | [] -> print_string ""
  | h::t -> print_string " ___   "; print_cards_top t

let rec print_cards_rank1 lst = 
  match lst with
  | [] -> print_string ""
  | h::t -> let rank = Deck.nth (String.split_on_char ' ' h) 0 in
    if rank = "Ten" then
      (print_string ("|" ^ Deck.rankstring_of_string rank ^ " |  "); 
       print_cards_rank1 t)
    else
      (print_string ("|" ^ Deck.rankstring_of_string rank ^ "  |  "); 
       print_cards_rank1 t)

let rec print_cards_suit lst = 
  match lst with
  | [] -> print_string ""
  | h::t -> let suit = Deck.nth (String.split_on_char ' ' h) 2 in
    if suit = "Hearts" || suit = "Diamonds" then
      (print_string ("| ");
       ANSITerminal.(print_string [red] (Deck.suitstring_of_string suit));
       print_string (" |  ");
       print_cards_suit t)
    else 
      (print_string ("| ");
       print_string (Deck.suitstring_of_string suit);
       (* ANSITerminal.(print_string [black] (Deck.suitstring_of_string suit)); *)
       print_string (" |  ");
       print_cards_suit t)

let rec print_cards_rank2 lst = 
  match lst with
  | [] -> print_string ""
  | h::t -> let rank = Deck.nth (String.split_on_char ' ' h) 0 in
    if rank = "Ten" then
      (print_string ("| " ^ Deck.rankstring_of_string rank ^ "|  "); 
       print_cards_rank2 t)
    else
      (print_string ("|  " ^ Deck.rankstring_of_string rank ^ "|  "); 
       print_cards_rank2 t)

let rec print_cards_bottom lst = 
  match lst with
  | [] -> print_string ""
  | h::t -> print_string " ‾‾‾   "; print_cards_bottom t

let print_cards lst =
  print_cards_top lst; print_string "\n";
  print_cards_rank1 lst; print_string "\n";
  print_cards_suit lst; print_string "\n";
  print_cards_rank2 lst; print_string "\n";
  print_cards_bottom lst; print_string "\n"

let print_piles lst =
  if List.length lst = 0 then
    (print_string "                           ___  \n";
     print_string "                          |░░░| \n";
     print_string "                          |░░░| \n";
     print_string "                          |░░░| \n";
     print_string "                           ‾‾‾  \n")
  else
    (print_cards_top lst; print_string "                    ___ \n";
     print_cards_rank1 lst; print_string "                   |░░░| \n";
     print_cards_suit lst; print_string "                   |░░░| \n";
     print_cards_rank2 lst; print_string "                   |░░░| \n";
     print_cards_bottom lst; print_string "                    ‾‾‾ \n")

let rec print_melds lst =
  match lst with
  | [] -> ()
  | h::t -> print_cards (Deck.string_of_deck h);
    print_string "\n"; 
    print_melds t

let change (new_st : State.result) (st : State.t) = 
  match new_st with 
  | Legal t -> t
  | Illegal -> 
    print_string "This is an illegal move.\n"; 
    st
  | Null t -> 
    print_string 
      "Less than two cards in stock. Game is null. New round starting... \n"; 
    st
  | Win t -> failwith "you shouldn't have won"

let handle_score (st : State.t) = 
  print_string "Your score is: " ; 
  print_int (State.get_current_player_score st);
  print_endline "\n"

let handle_hint (new_move : Optimal.move) (st : State.t) = 
  match new_move with
  | Discard t -> failwith "Unimplemented"
  | Draw t -> failwith "Unimplemented"
  | Knock -> failwith "Unimplemented"

let print_help st = 
  print_string "How to play Gin Rummy:";
  (* Rules of Gin Rummy *)
  print_endline "\n"

(** After Player 1 knocks in state [st], [knock] handles [new_st], 
    in which Player 2 is the current player and can choose cards to lay off. 
    The resulting state is an initialized subsequent round, unless
    a player wins and the game ends. *)
let rec knock (new_st : State.result) (st : State.t) : State.t =
  match new_st with 
  | Legal t -> t
  | Illegal -> print_string "You do not have less than 10 deadwood.\n"; st
  | Null t -> failwith "knock fail: null"
  | Win t -> failwith "knock fail: win"

let rec knock_match (st : State.t) : State.t =
  print_string (st |> State.get_opponent_player_name); print_string "'s Hand:\n";
  print_list (st |> State.get_opponent_player_hand |> Deck.string_of_deck);
  print_string ("\n");

  print_endline ("\nPlease list any cards you want to match. Separate cards with a single comma.");
  print_string  "> ";
  match read_line () with 
  | exception End_of_file -> 
    print_string "I don't know what you did, but... try again.\n"; st
  | read_line-> 
    match Deck.deck_of_string read_line with
    | exception Deck.Malformed ->
      print_endline "You cannot match these. Try again.\n"; 
      st
    | valid_deck -> match State.knock_match valid_deck st with
      | Legal new_st ->
        let winner_score = State.get_current_player_score new_st in
        let winner_name = State.get_current_player_name new_st in
        let loser_score = State.get_opponent_player_score new_st in
        let loser_name = State.get_opponent_player_name new_st in
        print_string winner_name; print_string "'s Score: "; 
        print_endline (winner_score |> string_of_int);
        print_string loser_name; print_string "'s Score: "; 
        print_endline (loser_score |> string_of_int);
        print_endline (winner_name ^ " has won this round!");
        new_st
      | Illegal -> print_string "Not all these cards form melds. Try again.\n"; 
        knock_match st
      | Null new_st -> failwith "knock fail"
      | Win new_st -> 
        let winner_score = State.get_current_player_score new_st in
        let winner_name = State.get_current_player_name new_st in
        let loser_score = State.get_opponent_player_score new_st in
        let loser_name = State.get_opponent_player_name new_st in
        print_string winner_name; print_string "'s Final Score: "; 
        print_endline (winner_score |> string_of_int);
        print_string loser_name; print_string "'s Final Score: "; 
        print_endline (loser_score |> string_of_int);
        print_string ("Congrats, " ^ winner_name ^ ", you've won!"); exit 0

(** [process_command] takes terminal input and executes a command. The command 
    may or may not change state but process_command always returns a state. *)
let process_command (command : Command.command) (st : State.t) =  
  match command with
  | Draw obj_phrase -> change (State.draw (String.concat " " obj_phrase) st) st
  | Discard obj_phrase -> (
      match (String.concat " " obj_phrase) |> Deck.card_of_string with 
      | exception Deck.Malformed -> 
        print_endline "You cannot discard this.\n"; 
        st
      | valid_card -> change (State.discard valid_card st) st)
  | Knock -> knock (State.knock_declare st) st
  | Match -> knock_match st
  | Pass -> change (State.pass st) st
  | Sort -> change (State.sort st) st
  | Hint -> handle_hint (Optimal.get_optimal st) st
  | Score -> handle_score st; st
  | Help -> print_help st; st
  | Quit -> exit 0

(*A function that either quits or executes a command based on input*)
let process_readline read_line (st : State.t) = 
  match Command.parse read_line with
  | exception Command.Empty ->
    print_endline "This is an invalid command.\n"; st
  | exception Command.Malformed ->
    print_endline "This is an malformed command.\n"; st
  | command -> (process_command command st)

(* Should initalize game but not initiate state transitions *)
let rec play_game (st : State.t) =
  print_string "\n----------------------------------------------------------\n";

  print_string "It is "; print_string (st |> State.get_current_player_name); 
  print_string "'s Turn:\n\n";

  print_string "Discard Pile:             Stock Pile:\n";
  print_piles (st |> State.get_discard |> Deck.string_of_hd);
  print_string ("\n");

  print_string (st |> State.get_current_player_name); print_string "'s Hand:\n";
  print_cards (st |> State.get_current_player_hand |> Deck.string_of_deck);
  print_string ("\n");

  (* Print melds of current player's hand *)
  print_string "\nMelds:\n";
  print_melds (st |> State.get_current_player_hand |> Deck.best_meld);
  print_string ("\n");

  (* Print deadwood of current player's hand *)
  print_string "Deadwood:\n";
  print_list (st |> State.get_current_player_hand |> Deck.deadwood 
              |> Deck.string_of_deck_short);
  print_string ("\n\n");

  (* Prompt for player to draw. *)
  print_endline ("Please enter a command.");
  print_string "> ";

  match read_line () with 
  | exception End_of_file -> ()
  | read_line -> let next_st = process_readline read_line st in 
    (play_game next_st)

(** [init_game n1 n2] starts a game of gin rummy with players [n1] and [n2]. *)
let init_game name1 name2 =
  let init = State.init_state (0, 0) 0 (name1,name2) in
  play_game init

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  print_endline "\n\nWelcome to Gin Rummy.\n";
  print_endline "Please enter your name, Player 1.\n";
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | name1 -> 
    print_endline "Please enter your name, Player 2.\n";
    print_string  "> ";
    match read_line () with
    | exception End_of_file -> ()
    | name2 -> init_game name1 name2

(* Execute the game engine. *)
let () = main ()
