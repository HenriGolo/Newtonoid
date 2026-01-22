type t = {
  x : float;
  y : float;
  width : float;
  height : float;
  vx : float;
}
(* CONTRACT
   Function that creates a new paddle instance.
   Type: x:float -> y:float -> width:float -> height:float -> t
   Parameter: x (float), the horizontal coordinate of the bottom-left corner
   Parameter: y (float), the vertical coordinate of the bottom-left corner
   Parameter: width (float), the width of the paddle
   Parameter: height (float), the height of the paddle
   Result: an instance of type t initialized with the given dimensions and a velocity (vx) of 0.
*)
let create ~x ~y ~width ~height = { x; y; width; height; vx = 0. }

(* CONTRACT
   Function that renders the paddle on the screen.
   Type: t -> unit
   Parameter: paddle (t), the paddle object containing position and dimensions
   Result: (unit), draws a filled rectangle representing the paddle.
*)
let draw (paddle : t) =
  Graphics.fill_rect
    (int_of_float paddle.x)
    (int_of_float paddle.y)
    (int_of_float paddle.width)
    (int_of_float paddle.height);