(* OASIS_START *)
(* OASIS_STOP *)

open Ocamlbuild_plugin;;

let bracket res destroy k =
  let x = try k res with e -> destroy res; raise e in
  destroy res;
  x

let cmd cmd =
  bracket
    (Unix.open_process_in cmd)
    (fun ch -> ignore & Unix.close_process_in ch)
    input_line

let git_describe () =
  try
    let id = cmd "git rev-parse HEAD" in
    Printf.sprintf "let id = \"(commit %s)\"" id
  with _ -> "let id = \"\""
;;

dispatch
  ( function
    | After_rules ->
      rule "git version" ~prod:"%GitVersion.ml"
        (fun env _ ->
          let v = git_describe() in
          let out = env "%GitVersion.ml" in
          Cmd (S [A "echo"; Quote (Sh v); Sh ">"; Px out]));
    | _ -> ());;
