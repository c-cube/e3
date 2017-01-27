# Change Log

## 0.3

- add flag `--check-proof` for checking SAT solver proofs
- remove parser for custom format; only keep TIP; remove .lisp from tests
- less accurate detection of incomplete expansions (without unsat-cores)
- bugfixes in uninterpreted types
- detect some evaluation loops with a `term_being_evaled` field
- internal notion of `undefined` for `asserting`, loops, and selectors
- simple prefix skolemization for `assert` axioms
- add `asserting` construct
- delay a bit combinatorial explosion for HO functions
- support for HO unknowns
- allow quantification over booleans, translated as conjunction/disjunction
- better error message for HO metas
- add support for selectors
