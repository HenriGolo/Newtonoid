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
let create ~x ~y ~radius ~vx ~vy = { x; y; radius; vx; vy }

(* CONTRACT
   Function that simulates the movement of a ball during a dt
   Type: t -> float -> t
   Parameter: ball (t), the ball we want to move
   Parameter: dt (float), the vertical coordinate of the bottom-left corner
   Result: an instance of type t initialized with the given coordonates, radius and velocity.
*)
let move ball dt =
  {
    ball with
    x = ball.x +. ball.vx *. dt;
    y = ball.y +. ball.vy *. dt;
  }

(* CONTRACT
   function that returns a ball that has bounced along the x-axis
   Type: t -> t
   Parameter: ball (t), the intitial ball
   Result: a new ball that has bounced along the x-axis.
*)
let bounce_x ball = { ball with vx = -. ball.vx }

(* CONTRACT
   function that returns a ball that has bounced along the y-axis
   Type: t -> t
   Parameter: ball (t), the intitial ball
   Result: a new ball that has bounced along the y-axis.
*)
let bounce_y ball = { ball with vy = -. ball.vy }

(* CONTRACT
   function that returns a ball that has bounced in a corner
   Type: t -> t
   Parameter: ball (t), the intitial ball
   Result: a new ball that has bounced in a corner.
*)
let bounce_corner ball = { ball with vx = -. ball.vy; vy = -. ball.vx }

(* CONTRACT
   Function that renders the ball on the screen.
   Type: t -> unit
   Parameter: ball (t), the ball instance
   Result: (unit), draws a filled circle representing the ball.
*)
let draw (b : t) =
  let open Graphics in
  fill_circle (int_of_float b.x) (int_of_float b.y) (int_of_float b.radius)

(* CONTRACT
   Function that cap the speed of a ball b.
   Type: t -> float -> t
   Parameter: b (t), the ball we want to cap.
   Parameter: max_v (float), the max speed
   Result: (t), the same ball or a ball with limited speed if needed.
*)
let cap_speed b max_v =
  let v = sqrt (b.vx *. b.vx +. b.vy *. b.vy) in
  if v > max_v then
    let ratio = max_v /. v in
    { b with vx = b.vx *. ratio; vy = b.vy *. ratio }
  else b

(* CONTRACT
   Function that multiply the speed of a ball.
   Type: float -> t -> t
   Parameter: factor (float), the ball we want to accelerate
   Parameter: b (t), the ball we want to accelerate
   Result: (t), the accelerated ball.
*)
let accelerate factor b =
  { b with vx = b.vx *. factor; vy = b.vy *. factor }