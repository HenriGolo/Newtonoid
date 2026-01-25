type t = {
  x : float;
  y : float;
  radius : float;
  vx : float;
  vy : float;
}

(* CONTRACT
   Function that creates a new ball instance.
   Type: float -> float -> float -> float -> float -> t
   Parameter: x (float), the horizontal coordinate of the bottom-left corner
   Parameter: y (float), the vertical coordinate of the bottom-left corner
   Parameter: radius (float), the the radius of the ball
   Parameter: vx (float), the horizontal speed of the ball
   Parameter: vy (float), the vertical speed of the ball
   Result: an instance of type t initialized with the given coordonates, radius and velocity.
*)
val create : x:float -> y:float -> radius:float -> vx:float -> vy:float -> t

(* CONTRACT
   Function that simulates the movement of a ball during a dt
   Type: t -> float -> t
   Parameter: ball (t), the ball we want to move
   Parameter: dt (float), the vertical coordinate of the bottom-left corner
   Result: an instance of type t initialized with the given coordonates, radius and velocity.
*)
val move : t -> float -> t

(* CONTRACT
   function that returns a ball that has bounced along the x-axis
   Type: t -> t
   Parameter: ball (t), the intitial ball
   Result: a new ball that has bounced along the x-axis.
*)
val bounce_x : t -> t

(* CONTRACT
   function that returns a ball that has bounced along the y-axis
   Type: t -> t
   Parameter: ball (t), the intitial ball
   Result: a new ball that has bounced along the y-axis.
*)
val bounce_y : t -> t

(* CONTRACT
   function that returns a ball that has bounced in a corner
   Type: t -> t
   Parameter: ball (t), the intitial ball
   Result: a new ball that has bounced in a corner.
*)
val bounce_corner : t -> t

(* CONTRACT
   Function that renders the ball on the screen.
   Type: t -> unit
   Parameter: ball (t), the ball instance
   Result: (unit), draws a filled circle representing the ball.
*)
val draw : t -> unit

(* CONTRACT
   Function that cap the speed of a ball b.
   Type: t -> float -> t
   Parameter: b (t), the ball we want to cap.
   Parameter: max_v (float), the max speed
   Result: (t), the same ball or a ball with limited speed if needed.
*)
val cap_speed : t -> float -> t

(* CONTRACT
   Function that multiply the speed of a ball.
   Type: float -> t -> t
   Parameter: factor (float), the ball we want to accelerate
   Parameter: b (t), the ball we want to accelerate
   Result: (t), the accelerated ball.
*)
val accelerate : float -> t -> t