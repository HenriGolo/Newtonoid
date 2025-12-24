type t = {
  x : float;
  y : float;
  width : float;
  height : float;
}

let create ~x ~y ~width ~height = { x; y; width; height }

let draw (b : t) =
  let open Graphics in
  draw_rect (int_of_float b.x) (int_of_float b.y) (int_of_float b.width) (int_of_float b.height)