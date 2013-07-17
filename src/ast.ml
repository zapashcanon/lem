(* generated by Ott 0.21.2 from: lem.ott *)


type text = Ulib.Text.t

type l =
  | Unknown
  | Trans of string * l option
  | Range of Lexing.position * Lexing.position

exception Parse_error_locn of l * string

type ml_comment = 
  | Chars of Ulib.Text.t
  | Comment of ml_comment list

type lex_skip =
  | Com of ml_comment
  | Ws of Ulib.Text.t
  | Nl

type lex_skips = lex_skip list option

let pp_lex_skips ppf sk = 
  match sk with
    | None -> ()
    | Some(sks) ->
        List.iter
          (fun sk ->
             match sk with
               | Com(ml_comment) ->
                   (* TODO: fix? *)
                   Format.fprintf ppf "(**)"
               | Ws(r) ->
                   Format.fprintf ppf "%s" (Ulib.Text.to_string r)
               | Nl -> Format.fprintf ppf "\\n")
          sks

let combine_lex_skips s1 s2 =
  match (s1,s2) with
    | (None,_) -> s2
    | (_,None) -> s1
    | (Some(s1),Some(s2)) -> Some(s2@s1)

type terminal = lex_skips


type x = terminal * text (* Variables *)
type ix = terminal * text (* Variables *)

type 
x_l =  (* Location-annotated names *)
   X_l of x * l
 | PreX_l of terminal * ix * terminal * l (* Remove infix status *)


type 
ix_l =  (* Location-annotated infix names *)
   SymX_l of ix * l

let xl_to_l = function
  | X_l(_,l) -> l
  | PreX_l(_,_,_,l) -> l

let ixl_to_l = function
  | SymX_l(_,l) -> l


type
n = terminal * text


type
a = terminal * text


type 
nexp_aux =  (* Numerical expressions for specifying vector lengths and indexes *)
   Nexp_var of n
 | Nexp_constant of terminal * int
 | Nexp_times of nexp * terminal * nexp
 | Nexp_sum of nexp * terminal * nexp
 | Nexp_paren of terminal * nexp * terminal

and nexp =  (* Location-annotated vector lengths *)
   Length_l of nexp_aux * l


type 
a_l =  (* Location-annotated type variables *)
   A_l of a * l


type 
n_l =  (* Location-annotated numeric variables *)
   N_l of n * l


type 
id =  (* Long identifers *)
   Id of ((x_l * terminal)) list * x_l * l


type 
nexp_constraint_aux =  (* Whether a vector is bounded or fixed size *)
   Fixed of nexp * terminal * nexp
 | Bounded of nexp * terminal * nexp


type 
tnvar =  (* Union of type variables and Nexp type variables, with locations *)
   Avl of a_l
 | Nvl of n_l


type 
lit_aux =  (* Literal constants *)
   L_true of terminal
 | L_false of terminal
 | L_num of terminal * int
 | L_hex of terminal * string (* hex and bin are constant bit vectors, entered as C-style hex or binaries *)
 | L_bin of terminal * string
 | L_string of terminal * Ulib.UTF8.t
 | L_unit of terminal * terminal
 | L_zero of terminal (* bitzero and bitone are constant bits, if commonly used we will consider overloading 0 and 1 *)
 | L_one of terminal


type 
typ_aux =  (* Types *)
   Typ_wild of terminal (* Unspecified type *)
 | Typ_var of a_l (* Type variables *)
 | Typ_fn of typ * terminal * typ (* Function types *)
 | Typ_tup of (typ * terminal) list (* Tuple types *)
 | Typ_Nexps of nexp (* As a typ to permit applications over Nexps, otherwise not accepted *)
 | Typ_app of id * (typ) list (* Type applications *)
 | Typ_paren of terminal * typ * terminal

and typ =  (* Location-annotated types *)
   Typ_l of typ_aux * l


type 
nexp_constraint =  (* Location-annotated Nexp range *)
   Range_l of nexp_constraint_aux * l


type 
c =  (* Typeclass constraints *)
   C of id * tnvar


type 
lit = 
   Lit_l of lit_aux * l (* Location-annotated literal constants *)


type 
p =  (* Unique paths *)
   Path_def of ((x * terminal)) list * x
 | Path_list of terminal
 | Path_bool of terminal
 | Path_num of terminal
 | Path_set of terminal
 | Path_string of terminal
 | Path_unit of terminal
 | Path_bit of terminal
 | Path_vector of terminal


type 
ne =  (* internal numeric expressions *)
   Ne_var of n
 | Ne_const of int
 | Ne_mult of ne * terminal * ne
 | Ne_add of ne * terminal * ne
 | Ne_unary of terminal * terminal * ne * terminal


type 
cs =  (* Typeclass and length constraint lists *)
   Cs_empty
 | Cs_classes of (c * terminal) list * terminal (* Must have $>0$ constraints *)
 | Cs_lengths of (nexp_constraint * terminal) list * terminal (* Must have $>0$ constraints *)
 | Cs_both of (c * terminal) list * terminal * (nexp_constraint * terminal) list * terminal (* Must have $>0$ of both form of constraints *)


type 
pat_aux =  (* Patterns *)
   P_wild of terminal (* Wildcards *)
 | P_as of terminal * pat * terminal * x_l * terminal (* Named patterns *)
 | P_typ of terminal * pat * terminal * typ * terminal (* Typed patterns *)
 | P_app of id * (pat) list (* Single variable and constructor patterns *)
 | P_record of terminal * (fpat * terminal) list * terminal * bool * terminal (* Record patterns *)
 | P_vector of terminal * (pat * terminal) list * terminal * bool * terminal (* Vector patterns *)
 | P_vectorC of terminal * (pat) list * terminal (* Concatenated vector patterns *)
 | P_tup of terminal * (pat * terminal) list * terminal (* Tuple patterns *)
 | P_list of terminal * (pat * terminal) list * terminal * bool * terminal (* List patterns *)
 | P_paren of terminal * pat * terminal
 | P_cons of pat * terminal * pat (* Cons patterns *)
 | P_num_add of x_l * terminal * terminal * int (* constant addition patterns *)
 | P_lit of lit (* Literal constant patterns *)

and pat =  (* Location-annotated patterns *)
   Pat_l of pat_aux * l

and fpat =  (* Field patterns *)
   Fpat of id * terminal * pat * l


type 
q =  (* Quantifiers *)
   Q_forall of terminal
 | Q_exists of terminal


type 
tannot_opt =  (* Optional type annotations *)
   Typ_annot_none
 | Typ_annot_some of terminal * typ


type 
ctor_def =  (* Datatype definition clauses *)
   Cte of x_l * terminal * (typ * terminal) list


type 
t =  (* Internal types *)
   T_var of a
 | T_fn of t * terminal * t
 | T_tup of (t * terminal) list
 | T_app of p * t_args
 | T_len of ne

and t_args =  (* Lists of types *)
   T_args of (t) list


type 
tnv =  (* Union of type variables and Nexp type variables, without locations *)
   Av of a
 | Nv of n


type 
c_pre =  (* Type and instance scheme prefixes *)
   C_pre_empty
 | C_pre_forall of terminal * (tnvar) list * terminal * cs (* Must have $>0$ type variables *)


type 
target =  (* Backend target names *)
   Target_hol of terminal
 | Target_isa of terminal
 | Target_ocaml of terminal
 | Target_coq of terminal
 | Target_tex of terminal
 | Target_html of terminal


type 
exp_aux =  (* Expressions *)
   Ident of id (* Identifiers *)
 | Nvar of n (* Nexp var, has type num *)
 | Fun of terminal * psexp (* Curried functions *)
 | Function of terminal * terminal * bool * (pexp * terminal) list * terminal (* Functions with pattern matching *)
 | App of exp * exp (* Function applications *)
 | Infix of exp * ix_l * exp (* Infix applications *)
 | Record of terminal * fexps * terminal (* Records *)
 | Recup of terminal * exp * terminal * fexps * terminal (* Functional update for records *)
 | Field of exp * terminal * id (* Field projection for records *)
 | Vector of terminal * (exp * terminal) list * terminal * bool * terminal (* Vector instantiation *)
 | VAccess of exp * terminal * nexp * terminal (* Vector access *)
 | VAccessR of exp * terminal * nexp * terminal * nexp * terminal (* Subvector extraction *)
 | Case of terminal * exp * terminal * terminal * bool * (pexp * terminal) list * l * terminal (* Pattern matching expressions *)
 | Typed of terminal * exp * terminal * typ * terminal (* Type-annotated expressions *)
 | Let of terminal * letbind * terminal * exp (* Let expressions *)
 | Tup of terminal * (exp * terminal) list * terminal (* Tuples *)
 | Elist of terminal * (exp * terminal) list * terminal * bool * terminal (* Lists *)
 | Paren of terminal * exp * terminal
 | Begin of terminal * exp * terminal (* Alternate syntax for $\ottnt(exp)$ *)
 | If of terminal * exp * terminal * exp * terminal * exp (* Conditionals *)
 | Cons of exp * terminal * exp (* Cons expressions *)
 | Lit of lit (* Literal constants *)
 | Setcomp of terminal * exp * terminal * exp * terminal (* Set comprehensions *)
 | Setcomp_binding of terminal * exp * terminal * terminal * (qbind) list * terminal * exp * terminal (* Set comprehensions with explicit binding *)
 | Set of terminal * (exp * terminal) list * terminal * bool * terminal (* Sets *)
 | Quant of q * (qbind) list * terminal * exp (* Logical quantifications *)
 | Listcomp of terminal * exp * terminal * terminal * (qbind) list * terminal * exp * terminal (* List comprehensions (all binders must be quantified) *)
 | Do of terminal * id * ((pat * terminal * exp * terminal)) list * terminal * exp * terminal (* Do notation for monads *)

and exp =  (* Location-annotated expressions *)
   Expr_l of exp_aux * l

and qbind =  (* Bindings for quantifiers *)
   Qb_var of x_l
 | Qb_restr of terminal * pat * terminal * exp * terminal (* Restricted quantifications over sets *)
 | Qb_list_restr of terminal * pat * terminal * exp * terminal (* Restricted quantifications over lists *)

and fexp =  (* Field-expressions *)
   Fexp of id * terminal * exp * l

and fexps =  (* Field-expression lists *)
   Fexps of (fexp * terminal) list * terminal * bool * l

and pexp =  (* Pattern matches *)
   Patexp of pat * terminal * exp * l

and psexp =  (* Multi-pattern matches *)
   Patsexp of (pat) list * terminal * exp * l

and funcl_aux =  (* Function clauses *)
   Funcl of x_l * (pat) list * tannot_opt * terminal * exp

and letbind_aux =  (* Let bindings *)
   Let_val of pat * tannot_opt * terminal * exp (* Value bindings *)
 | Let_fun of funcl_aux (* Function bindings *)

and letbind =  (* Location-annotated let bindings *)
   Letbind of letbind_aux * l


type 
texp =  (* Type definition bodies *)
   Te_abbrev of typ (* Type abbreviations *)
 | Te_record of terminal * ((x_l * terminal * typ) * terminal) list * terminal * bool * terminal (* Record types *)
 | Te_variant of terminal * bool * (ctor_def * terminal) list (* Variant types *)


type 
name_t =  (* Name or name with type for inductively defined relation clauses *)
   Name_t_name of x_l
 | Name_t_nt of terminal * x_l * terminal * typ * terminal


type 
witness_opt =  (* Optional witness type name declaration. Must be present for a witness type to be generated. *)
   Witness_none
 | Witness_some of terminal * terminal * x_l * terminal


type 
check_opt =  (* Option check name declaration *)
   Check_none
 | Check_some of terminal * x_l * terminal


type 
functions_opt =  (* Optional names and types for functions to be generated. Types should use only in, out, unit, or the witness type *)
   Functions_none
 | Functions_one of x_l * terminal * typ
 | Functions_some of x_l * terminal * typ * terminal * functions_opt


type 
typschm =  (* Type schemes *)
   Ts of c_pre * typ


type 
targets =  (* Backend target name lists *)
   Targets_concrete of terminal * (target * terminal) list * terminal
 | Targets_neg_concrete of terminal * (target * terminal) list * terminal (* all targets except the listed ones *)


type 
dexp =  (* declaration field-expressions *)
   Dexp_name of terminal * terminal * terminal * Ulib.UTF8.t * l
 | Dexp_format of terminal * terminal * terminal * Ulib.UTF8.t * l
 | Dexp_arguments of terminal * terminal * (exp) list * l
 | Dexp_targuments of terminal * terminal * (texp) list * l


type 
rule_aux =  (* Inductively defined relation clauses *)
   Rule of x_l * terminal * terminal * (name_t) list * terminal * exp * terminal * x_l * (exp) list


type 
indreln_name_aux =  (* Name for inductively defined relation *)
   Inderln_name_Name of terminal * x_l * terminal * typschm * witness_opt * check_opt * functions_opt * terminal


type 
name_opt =  (* Optional name specification for variables of defined type *)
   Name_sect_none
 | Name_sect_name of terminal * x_l * terminal * terminal * string * terminal


type 
lemma_typ =  (* Types of Lemmata *)
   Lemma_assert of terminal
 | Lemma_lemma of terminal
 | Lemma_theorem of terminal


type 
declare_arg =  (* agruments to a declaration *)
   Decl_arg_string of terminal * Ulib.UTF8.t
 | Decl_arg_record of terminal * (dexp * terminal) list * terminal * bool * l * terminal


type 
funcl =  (* Location-annotated function clauses *)
   Rec_l of funcl_aux * l


type 
nec =  (* Numeric expression constraints *)
   Lessthan of ne * terminal * nec
 | Eq of ne * terminal * nec
 | Lteq of ne * terminal * nec
 | Base of ne


type 
rule =  (* Location-annotated inductively defined relation clauses *)
   Rule_l of rule_aux * l


type 
indreln_name =  (* Location-annotated name for inductively defined relations *)
   Name_l of indreln_name_aux * l


type 
td =  (* Type definitions *)
   Td of x_l * tnvar list * name_opt * terminal * texp
 | Td_opaque of x_l * tnvar list * name_opt (* Definitions of opaque types *)


type 
instschm =  (* Instance schemes *)
   Is of c_pre * terminal * id * typ * terminal


type 
lemma_decl =  (* Lemmata and Tests *)
   Lemma_named of lemma_typ * targets option * x_l * terminal * terminal * exp * terminal
 | Lemma_unnamed of lemma_typ * targets option * terminal * exp * terminal


type 
declare_def =  (* declarations *)
   Decl_target_type of terminal * targets option * terminal * x_l * tnvar list * terminal * declare_arg (* target type declaration *)
 | Decl_target_const of terminal * targets option * terminal * x_l * (pat) list * terminal * declare_arg (* target constant declaration *)


type 
val_def =  (* Value definitions *)
   Let_def of terminal * targets option * letbind (* Non-recursive value definitions *)
 | Let_rec of terminal * terminal * targets option * (funcl * terminal) list (* Recursive function definitions *)
 | Let_inline of terminal * terminal * targets option * letbind (* Function definitions to be inlined *)


type 
val_spec =  (* Value type specifications *)
   Val_spec of terminal * x_l * terminal * typschm


type 
def_aux =  (* Top-level definitions *)
   Type_def of terminal * (td * terminal) list (* Type definitions *)
 | Val_def of val_def (* Value definitions *)
 | Lemma of lemma_decl (* Lemmata *)
 | Declaration of declare_def (* a declaration that modifies Lem's behaviour *)
 | Ident_rename of terminal * targets option * id * terminal * x_l (* Rename constant or type *)
 | Module of terminal * x_l * terminal * terminal * defs * terminal (* Module definitions *)
 | Rename of terminal * x_l * terminal * id (* Module renamings *)
 | Open of terminal * id (* Opening modules *)
 | Indreln of terminal * targets option * (indreln_name * terminal) list * (rule * terminal) list (* Inductively defined relations *)
 | Spec_def of val_spec (* Top-level type constraints *)
 | Class of terminal * terminal * x_l * tnvar * terminal * ((terminal * x_l * terminal * typ * l)) list * terminal (* Typeclass definitions *)
 | Instance of terminal * instschm * ((val_def * l)) list * terminal (* Typeclass instantiations *)

and def =  (* Location-annotated definitions *)
   Def_l of def_aux * l

and defs =  (* Definition sequences *)
   Defs of ((def * terminal * bool)) list


type 
name_ts =  (* Names with optional types for inductively defined relation clauses *)
   NameTs of (name_t) list


type 
semC =  (* Typeclass constraint lists *)
   SemC_concrete of ((terminal * p * tnv * terminal)) list


type 
env_tag =  (* Tags for the (non-constructor) value descriptions *)
   Method of terminal (* Bound to a method *)
 | Spec of terminal (* Specified with val *)
 | Def of terminal (* Defined with let or indreln *)


type 
v_desc =  (* Value descriptions *)
   V_constr of terminal * terminal * tnv list * terminal * t list * terminal * p * terminal * terminal * x * terminal * Set.Make(String).t * terminal * terminal (* Constructors *)
 | V_val of terminal * terminal * tnv list * terminal * semC * terminal * t * terminal * env_tag * terminal (* Values *)


type 
f_desc = 
   F_field of terminal * terminal * tnv list * terminal * p * terminal * t * terminal * terminal * x * terminal * Set.Make(String).t * terminal * terminal (* Fields *)


type 
tc_def =  (* Type and class constructor definitions *)
   Tc_def of tnv list * t option (* Type constructors *)


type 
inst =  (* A typeclass instance, t must not contain nested types *)
   Inst of semC * terminal * terminal * p * t * terminal

(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)
(** definitions *)


