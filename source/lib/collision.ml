let collision (ball:Ball.t) (brick:Brick.t) =
  let ball_left = ball.x -. ball.radius in
  let ball_right = ball.x +. ball.radius in
  let ball_top = ball.y +. ball.radius in
  let ball_bottom = ball.y -. ball.radius in

  let brick_left = brick.x in
  let brick_right = brick.x +. brick.width in
  let brick_bottom = brick.y in
  let brick_top = brick.y +. brick.height in

  (* intersection ? *)
  let intersect = 
    ball_right >= brick_left && ball_left <= brick_right &&
    ball_top >= brick_bottom && ball_bottom <= brick_top 
  in

  if not intersect then (ball, false)
  else
    (* determination du coté choqué *)
    
    if ball.x >= brick_left && ball.x <= brick_right then
      (* Choc Vertical *)
      (Ball.bounce_y ball, true)
    else if ball.y >= brick_bottom && ball.y <= brick_top then
      (* Choc Horizontal *)
      (Ball.bounce_x ball, true)
    else
      (* Choc sur un coin *)
      (Ball.bounce_corner ball, true)

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