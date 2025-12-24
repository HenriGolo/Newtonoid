type t = {
  x : float;
  y : float;
  radius : float;
  vx : float;
  vy : float;
}

let create ~x ~y ~radius ~vx ~vy = { x; y; radius; vx; vy }

let move ball dt =
  {
    ball with
    x = ball.x +. ball.vx *. dt;
    y = ball.y +. ball.vy *. dt;
  }

let bounce_x ball = { ball with vx = -. ball.vx }
let bounce_y ball = { ball with vy = -. ball.vy }
let bounce_corner ball = { ball with vx = -. ball.vy; vy = -. ball.vx }

let draw (b : t) =
  let open Graphics in
  fill_circle (int_of_float b.x) (int_of_float b.y) (int_of_float b.radius)