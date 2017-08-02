
(* This file is free software. See file "license" for more details. *)

(** {1 Basic AST for rewriting} *)

type var = Ty.t Var.t

type unop = U_not
type binop = B_eq | B_leq | B_lt | B_and | B_or

type term = {
  view: term_view;
  ty: Ty.t;
}
and term_view =
  | Var of var (* bound var, for rules *)
  | Const of cst
  | Unknown of var (* meta-variable *)
  | App of term * term list
  | Bool of bool
  | If of term * term * term
  | Unop of unop * term
  | Binop of binop * term * term
  | Undefined of Ty.t

and cst = {
  cst_id : ID.t;
  cst_ty : Ty.t;
  cst_def : rule list;
}

(* [cst args --> rhs] *)
and rule = term list * term

type statement =
  | St_data of Ty.data list (* declare mutual datatypes *)
  | St_def of cst * Ast.term option (* define constant (with backup value) *)
  | St_goal of term (* boolean term *)

module Cst : sig
  type t = cst
  val ty : t -> Ty.t
  val mk : ID.t -> Ty.t -> rule list -> t
  val pp : t CCFormat.printer
end

module T : sig
  type t = term

  val view : t -> term_view
  val ty : t -> Ty.t

  val var : var -> t
  val const : cst -> t
  val app : t -> t list -> t
  val app_cst : cst -> t list -> t
  val bool : bool -> t
  val unop : unop -> t -> t
  val binop : binop -> t -> t -> t
  val unknown : var -> t
  val undefined : Ty.t -> t

  val pp : t CCFormat.printer
end

module Stmt : sig
  type t = statement

  val goal : term -> t
  val data : Ty.data list -> t
  val def : ?def:Ast.term -> cst -> t

  val pp : t CCFormat.printer
end

module Var_map : CCMap.S with type key = var
module Var_tbl : CCHashtbl.S with type key = var