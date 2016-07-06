
(* This file is free software. See file "license" for more details. *)

(** {1 Preprocessing AST} *)

type 'a or_error = ('a, string) CCResult.t
type sexp = CCSexp.t
type 'a to_sexp = 'a -> sexp

(** {2 Types} *)

module Var : sig
  type 'ty t = private {
    id: ID.t;
    ty: 'ty;
  }

  val make : ID.t -> 'ty -> 'ty t
  val copy : 'a t -> 'a t
  val ty : 'a t -> 'a

  val equal : 'a t -> 'a t -> bool
  val pp : _ t CCFormat.printer
  val to_sexp : 'ty to_sexp -> 'ty t to_sexp
end

module Ty : sig
  type t =
    | Prop
    | Const of ID.t
    | Arrow of t * t

  val prop : t
  val const : ID.t -> t
  val arrow : t -> t -> t
  val arrow_l : t list -> t -> t

  include Intf.EQ with type t := t
  include Intf.ORD with type t := t
  include Intf.HASH with type t := t
  include Intf.PRINT with type t := t

  val unfold : t -> t list * t
  (** [unfold ty] will get the list of arguments, and the return type
      of any function. An atomic type is just a function with no arguments *)

  val to_sexp : t to_sexp

  (** {2 Datatypes} *)

  (** Mutually recursive datatypes *)
  type data = {
    data_id: ID.t;
    data_cstors: t ID.Map.t;
  }

  val data_to_sexp : data -> sexp

  (** {2 Error Handling} *)

  exception Ill_typed of string

  val ill_typed : ('a, Format.formatter, unit, 'b) format4 -> 'a
end

type var = Ty.t Var.t

type binop =
  | And
  | Or
  | Imply

type term = private {
  term: term_cell;
  ty: Ty.t;
}
and term_cell =
  | Var of var
  | Const of ID.t
  | App of term * term list
  | If of term * term * term
  | Match of term * (var list * term) ID.Map.t
  | Fun of var * term
  | Eq of term * term
  | Not of term
  | Binop of binop * term * term
  | True
  | False

(* TODO: records? *)

type definition = ID.t * Ty.t * term

type statement =
  | Data of Ty.data list
  | TyDecl of ID.t (* new atomic cstor *)
  | Decl of ID.t * Ty.t
  | Define of definition list
  | Assert of term
  | Goal of var list * term

(** {2 Constructors} *)

val var : var -> term
val const : ID.t -> Ty.t -> term
val app : term -> term list -> term
val if_ : term -> term -> term -> term
val match_ : term -> (var list * term) ID.Map.t -> term
val fun_ : var -> term -> term
val fun_l : var list -> term -> term
val eq : term -> term -> term
val not_ : term -> term
val binop : binop -> term -> term -> term
val and_ : term -> term -> term
val and_l : term list -> term
val or_ : term -> term -> term
val or_l : term list -> term
val imply : term -> term -> term
val true_ : term
val false_ : term

(** {2 Printing} *)

val term_to_sexp : term to_sexp
val statement_to_sexp : statement to_sexp

val pp_term : term CCFormat.printer
val pp_statement : statement CCFormat.printer

(** {2 Parsing and Typing} *)

module Ctx : sig
  type t
  val create: unit -> t
  include Intf.PRINT with type t := t
end

val term_of_sexp : Ctx.t -> sexp -> term or_error

val statement_of_sexp : Ctx.t -> sexp -> statement or_error

val statements_of_sexps :
  ?init:Ctx.t -> sexp list -> statement list or_error

