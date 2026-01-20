type t = {
  x : float;
  y : float;
  radius : float;
  vx : float;
  vy : float;
}

(** Creation of a ball **)
val create : x:float -> y:float -> radius:float -> vx:float -> vy:float -> t

(** Move the ball according to its velocity and the time delta **)
val move : t -> float -> t

(* Bouncing functions *)
val bounce_x : t -> t
val bounce_y : t -> t
val bounce_corner : t -> t

(** Draw the ball on the screen **)
val draw : t -> unit

(** Cap the speed of the ball to a maximum value **)
val cap_speed : t -> float -> t

(** Accelerate the ball by a given factor **)
val accelerate : float -> t -> t