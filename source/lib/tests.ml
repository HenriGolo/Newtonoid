open Collision

let brick_std = Brick.create ~x:0. ~y:0. ~width:20. ~height:20. ~value:1

let check_hit ball brick =
  let (_, hit) = collision ball brick in
  hit

let %test "pas de collision loin" =
  let ball_far = Ball.create ~x:100. ~y:100. ~radius:5. ~vx:1. ~vy:1. in
  check_hit ball_far brick_std = false

let %test "collision verticale haute" =
  let ball_vt = Ball.create ~x:10. ~y:14. ~radius:5. ~vx:0. ~vy:(-2.) in
  let brick_vt = Brick.create ~x:0. ~y:0. ~width:20. ~height:10. ~value:1 in
  check_hit ball_vt brick_vt = true

let %test "collision verticale basse" =
  let ball_vb = Ball.create ~x:10. ~y:1. ~radius:3. ~vx:0. ~vy:2. in
  let brick_vb = Brick.create ~x:0. ~y:3. ~width:20. ~height:4. ~value:1 in
  check_hit ball_vb brick_vb = true

let %test "collision horizontale droite" =
  let ball_hr = Ball.create ~x:24. ~y:10. ~radius:5. ~vx:(-2.) ~vy:0. in
  check_hit ball_hr brick_std = true

let %test "collision coin bas-gauche (touche)" =
  let ball_corner = Ball.create ~x:(-2.) ~y:(-2.) ~radius:4. ~vx:2. ~vy:2. in
  check_hit ball_corner brick_std = true

let %test "rebond vertical inverse vy" =
  let ball = Ball.create ~x:10. ~y:22. ~radius:5. ~vx:2. ~vy:(-2.) in
  let (new_ball, hit) = collision ball brick_std in
  hit && new_ball.vy > 0.

let %test "rebond horizontal inverse vx" =
  let ball = Ball.create ~x:(-2.) ~y:10. ~radius:5. ~vx:2. ~vy:2. in
  let (new_ball, hit) = collision ball brick_std in
  hit && new_ball.vx < 0. 