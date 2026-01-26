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

let %test "quadtree create_borders" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:50. in
  b.x = 0. && b.y = 0. && b.width = 100. && b.height = 50.

let %test "quadtree contains inside" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:100. in
  let brick_inside = Brick.create ~x:50. ~y:50. ~width:10. ~height:10. ~value:1 in
  Quadtree.contains b brick_inside

let %test "quadtree contains outside" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:100. in
  let brick_outside = Brick.create ~x:150. ~y:150. ~width:10. ~height:10. ~value:1 in
  not (Quadtree.contains b brick_outside)

let %test "quadtree split" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:100. in
  let (nw, ne, sw, se) = Quadtree.split b in
  nw = Quadtree.create_borders ~x:0. ~y:0. ~width:50. ~height:50. &&
  ne = Quadtree.create_borders ~x:50. ~y:0. ~width:50. ~height:50. &&
  sw = Quadtree.create_borders ~x:0. ~y:50. ~width:50. ~height:50. &&
  se = Quadtree.create_borders ~x:50. ~y:50. ~width:50. ~height:50.

let %test "quadtree get_borders" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:100. in
  let b' = Quadtree.(get_borders (create b)) in
  b = b'

let %test "quadtree insert and query" =
  let qt = Quadtree.(create (create_borders ~x:0. ~y:0. ~width:100. ~height:100.)) in
  let brick1 = Brick.create ~x:10. ~y:10. ~width:10. ~height:10. ~value:1 in
  let brick2 = Brick.create ~x:70. ~y:70. ~width:10. ~height:10. ~value:1 in
  let qt = Quadtree.insert qt brick1 in
  let qt = Quadtree.insert qt brick2 in
  let query_area = Quadtree.create_borders ~x:0. ~y:0. ~width:50. ~height:50. in
  let found_bricks = Quadtree.query qt query_area in
  List.length found_bricks = 1 && List.hd found_bricks = brick1

let %test "quadtree intersect overlapping" =
  let b1 = Quadtree.create_borders ~x:0. ~y:0. ~width:50. ~height:50. in
  let b2 = Quadtree.create_borders ~x:25. ~y:25. ~width:50. ~height:50. in
  Quadtree.intersect b1 b2

let %test "quadtree intersect non-overlapping" =
  let b1 = Quadtree.create_borders ~x:0. ~y:0. ~width:50. ~height:50. in
  let b2 = Quadtree.create_borders ~x:100. ~y:100. ~width:50. ~height:50. in
  not (Quadtree.intersect b1 b2)

let %test "quadtree remove brick" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:100. in
  let qt = Quadtree.create b in
  let brick = Brick.create ~x:10. ~y:10. ~width:10. ~height:10. ~value:1 in
  let qt = Quadtree.insert qt brick in
  let qt = Quadtree.remove qt brick in
  let query_area = Quadtree.create_borders ~x:0. ~y:0. ~width:50. ~height:50. in
  let found_bricks = Quadtree.query qt query_area in
  List.length found_bricks = 0

let %test "quadtree count_bricks" =
  let b = Quadtree.create_borders ~x:0. ~y:0. ~width:100. ~height:100. in
  let qt = Quadtree.create b in
  let brick1 = Brick.create ~x:10. ~y:10. ~width:10. ~height:10. ~value:1 in
  let brick2 = Brick.create ~x:20. ~y:20. ~width:10. ~height:10. ~value:1 in
  let qt = Quadtree.insert qt brick1 in
  let qt = Quadtree.insert qt brick2 in
  Quadtree.count_bricks qt = 2
