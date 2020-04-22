(** 
   Representation of static game data.

   This module represents the data stored in the deck of cards and handles
   functions that allow other modules to access card information.
*)

(** The type of card suits. *)
type suit

(** The type of card numbers. *)
type number

(** The type of cards. *)
type card = number * suit

(** The abstract type of values representing card decks. *)
type t

(** [init_deck] is the initialized and sorted standard 52-card deck. *)
val init_deck : t

(** [shuffle deck] randomizes the order of [deck]. *)
val shuffle : t -> t

(** [suit_sort hand] sorts [hand] by suit first, then number. *)
val suit_sort : t -> t

(** [best_meld hand] returns a list of the meld combinations of [hand] that 
    results in the lowest deadwood value. *)
val best_meld : t -> t list

(** [deadwood hand] returns a list of the deadwood cards corresponding to
    the best meld. *)
val deadwood : t -> t

(** [deadwood_value hand] is the total int value of the deadwood in [hand]. *)
val deadwood_value : t -> int

(** [meld_value hand] is the total int value of the meld in [hand]. *)
val meld_value : t -> int

<<<<<<< HEAD
=======
(** [start_cards] creates an initialized and shuffled deck and returns a list
    that contains a list of stock pile cards, a list of discard pile cards, 
    and each player's starting hand. *)
>>>>>>> d0db4581be422a55d1904b28edd5fb546873fd79
val start_cards : t list