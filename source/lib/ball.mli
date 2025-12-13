type t = {
  x : float;
  y : float;
  radius : float;
  vx : float;
  vy : float;
}

(** Creation of a ball **)
val create : x:float -> y:float -> radius:float -> vx:float -> vy:float -> t