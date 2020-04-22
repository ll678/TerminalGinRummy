
open Deck

exception Malformed

<<<<<<< HEAD

=======
>>>>>>> d0db4581be422a55d1904b28edd5fb546873fd79
type p = {
  hand: Deck.t;
  score: int;
}

type t = {
  stock_pile: Deck.t;
  discard_pile : Deck.t;
  players : p list;
  current_player : int;
  dealer : int;
  last_move: (Command.command * Deck.card) option;
}

type result = Legal of t | Illegal

<<<<<<< HEAD

let init_players starting_cards starting_scores : p list = 
  [{
    hand = List.nth starting_cards 3 ;
    score = fst starting_scores;
  };{
     hand = List.nth starting_cards 4 ;
     score = snd starting_scores;
   }]

let init_state players_starting_scores start_player = 
  let starting_cards = Deck.start_cards in
=======
(** Return player list*)

let init_players starting_cards starting_scores = 
  [{
    hand = List.nth starting_cards 3 ;
    score = fst starting_scores;
  },{
      hand = List.nth starting_cards 4 ;
      score = snd starting_scores;
    }]

let init_state players_starting_scores current_player = 
  let starting_cards = start_cards in
>>>>>>> d0db4581be422a55d1904b28edd5fb546873fd79
  {
    stock_pile = List.nth starting_cards 1;
    discard_pile = List.nth starting_cards 2;
    players = init_players starting_cards players_starting_scores;
<<<<<<< HEAD
    current_player = start_player;
    dealer = start_player;
    last_move = None;
  }


=======
    current_player = current_player;
    last_move = None;
  }
>>>>>>> d0db4581be422a55d1904b28edd5fb546873fd79

(* 
let current_stock_pile st =
  st.stock_pile

let get_discard_pile st =
  st.discard_pile

let get_current_player st = 
  st.current_player

let get_players st = 
  st.players

let get_last_move st =
  st.last_move


(* We need to decide if the discard pile is ordered (which we would want in this case to get the faceup card) *)
let remove_top_card deck =
  match deck with
  | [] -> None
  | h::t -> t

let get_top_card deck =
  match deck with
  | [] -> None
  | h::t -> h

let update_player player st =
  if (st.current_player == 0) then 
    let player_hand = card::((fst st.p).hand) in 
    {
      hand = player_hand;
      score = value_of_hand player_hand
    }
  else 
    let player_hand = card::((snd st.p).hand) in 
    {
      hand = player_hand;
      score = value_of_hand player_hand
    }

let get_new_draw_state st deck location =
  let current_stock  = current_stock_pile st in
  let current_discard = get_discard_pile st in
  let current_player = get_current_player st in
  let card = if (location = "Stock") then get_top_card current_stock else get_top_card current_discard in
  {
    stock_pile = if (location="Stock") then (remove_top_card current_stock) 
      else current_stock;
    discard_pile = if (location="Discard") then (remove_top_card current_discard)
      else current_discard;
    players = update_player player st;
    current_player = if (current_player = 0) then 1 else 0;
    last_move = (Draw location,card);
  }

let draw_deck location deck st =
  if (List.mem location ["Stock","Discard"]) then  
    (let new_st = get_new_draw_state st deck location
     in
     Legal new_st) 
  else Illegal


let discard card prev_st = 
  if prev_st.last_move = (Draw "discard",card) then Illegal
  else
    Legal ({
        stock_pile: Deck.t;
        discard_pile : Deck.t;
        players : p list;
        current_player : p;
        dealer : int;
        last_move: command * Deck.card;

        stock_pile = prev_st.stock_pile;
        discard_pile = card :: prev_st.discard;
        players = prev_st.players;
        last_move = Discard (card);
        last_state = prev_st;
        players = Players.remove_card prev_st.current_player card
      }) *)