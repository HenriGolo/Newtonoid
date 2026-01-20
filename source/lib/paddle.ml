type t = {
  x : float;
  y : float;
  width : float;
  height : float;
  vx : float;
}

let create ~x ~y ~width ~height = { x; y; width; height; vx = 0. }

let draw (paddle : t) =
  Graphics.fill_rect
    (int_of_float paddle.x)
    (int_of_float paddle.y)
    (int_of_float paddle.width)
    (int_of_float paddle.height);