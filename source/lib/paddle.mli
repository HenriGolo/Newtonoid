type t = {
  x : float;
  y : float;
  width : float;
  height : float;
  vx : float;
  (*ajouter dx plus tard pour la cumulation des vitesses*)
}

(** Creation of a paddle **)
val create : x:float -> y:float -> width:float -> height:float -> t
(** Draw the paddle on the screen **)
val draw : t -> unit