(* Return couple new ball state + if it collides with the brick*)
let collision (ball:Ball.t) (brick:Brick.t) =
  (* we suppose 0,0 is bottom left *)

  (* position of nearest points on the ball's bounding box *)
  let ball_left = ball.x -. ball.radius in
  let ball_right = ball.x +. ball.radius in
  let ball_top = ball.y +. ball.radius in
  let ball_bottom = ball.y -. ball.radius in

  (* position of the brick's sides *)
  let brick_left = brick.x in
  let brick_right = brick.x +. brick.width in
  let brick_bottom = brick.y in
  let brick_top = brick.y +. brick.height in
  let brick_center_x = brick.x +. (brick.width /. 2.) in
  let brick_center_y = brick.y +. (brick.height /. 2.) in

  (* value of ball's radius squared *)
  let radius_squared = ball.radius *. ball.radius in
  
  (* compute distance squared between two points *)
  let corner_dist_squared (x1, y1) (x2, y2) =
      let dx = x1 -. x2 in
      let dy = y1 -. y2 in
      dx *. dx +. dy *. dy
  in

  (* compute distance squared between ball center and each corner of the brick *)
  let dist_corner_top_left = corner_dist_squared (ball.x, ball.y) (brick_left, brick_top) in
  let dist_corner_top_right = corner_dist_squared (ball.x, ball.y) (brick_right, brick_top) in
  let dist_corner_bottom_left = corner_dist_squared (ball.x, ball.y) (brick_left, brick_bottom) in
  let dist_corner_bottom_right = corner_dist_squared (ball.x, ball.y) (brick_right, brick_bottom) in

  if (brick_left <= ball.x && brick_right >= ball.x) then

    (* vertical case collision *)
    if (brick_center_y <= ball.y && ball_bottom <= brick_top) || (brick_center_y >= ball.y && ball_top >= brick_bottom) then
      (Ball.bounce_y ball, true)
    else
      (ball, false)

  else if (brick_bottom <= ball.y && brick_top >= ball.y) then
    
    (* horizontal case collision *)
    if (brick_center_x <= ball.x && ball_left <= brick_right) || (brick_center_x >= ball.x && ball_right >= brick_left) then
      (Ball.bounce_x ball, true)
    else
      (ball, false)

  else

    (* diagonal case collision *)
    if
    dist_corner_top_left <= radius_squared ||
    dist_corner_top_right <= radius_squared ||
    dist_corner_bottom_left <= radius_squared ||
    dist_corner_bottom_right <= radius_squared then
      (Ball.bounce_corner ball, true)
    else
      (ball, false)

;;

let ball_paddle (ball : Ball.t) (paddle : Paddle.t) =
  let (new_ball, hit) = collision ball (Brick.create ~x:paddle.x ~y:paddle.y ~width:paddle.width ~height:paddle.height ~value:0) in
  if hit then
    (* On ajoute un coeff de réduction de la vitesse de la raquette *)
    let updated_vx = new_ball.vx +. (paddle.vx *. Config.coeff_velocity) in
    ({ new_ball with vx = updated_vx }, true)
  else
    (new_ball, false)

(* Unit tests for collision detection (pas à jour, peut etre faire un fichier test.ml pour mettre les tests) *)
(*
let brick = Brick.create ~x:0. ~y:0. ~width:20. ~height:20.
let ball_far = Ball.create ~x:100. ~y:100. ~radius:5. ~vx:0. ~vy:0.
let %test _ = collision ball_far brick = false

let ball_vt = Ball.create ~x:10. ~y:14. ~radius:4. ~vx:0. ~vy:0.
let brick_vt = Brick.create ~x:0. ~y:0. ~width:20. ~height:10.
let %test _ = collision ball_vt brick_vt = true

let ball_vb = Ball.create ~x:10. ~y:1. ~radius:2. ~vx:0. ~vy:0.
let brick_vb = Brick.create ~x:0. ~y:3. ~width:20. ~height:4.
let %test _ = collision ball_vb brick_vb = true

let brick_h = Brick.create ~x:0. ~y:0. ~width:20. ~height:20.
let ball_hr = Ball.create ~x:25. ~y:10. ~radius:5. ~vx:0. ~vy:0.
let %test _ = collision ball_hr brick_h = true

let ball_hl = Ball.create ~x:(-5.) ~y:10. ~radius:5. ~vx:0. ~vy:0.
let %test _ = collision ball_hl brick_h = true

let ball_corner_touch = Ball.create ~x:(-3.) ~y:(-4.) ~radius:5. ~vx:0. ~vy:0.
let %test _ = collision ball_corner_touch brick_h = true

let ball_corner_far = Ball.create ~x:(-10.) ~y:(-10.) ~radius:5. ~vx:0. ~vy:0.
let %test _ = collision ball_corner_far brick_h = false
*)