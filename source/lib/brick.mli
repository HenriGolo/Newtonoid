type t = {
  x : float;
  y : float;
  width : float;
  height : float;
}

(** Creation of a brick **)
val create : x:float -> y:float -> width:float -> height:float -> t

(** Draw the brick on the screen **)
val draw : t -> unit