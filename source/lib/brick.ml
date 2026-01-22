type t = {
  x : float;
  y : float;
  width : float;
  height : float;
  value : int;
}

(* CONTRACT
   Function that creates a new brick instance.
   Type: x:float -> y:float -> width:float -> height:float -> t
   Parameter: x (float), the horizontal coordinate of the bottom-left corner
   Parameter: y (float), the vertical coordinate of the bottom-left corner
   Parameter: width (float), the width of the brick
   Parameter: height (float), the height of the brick
   Result: an instance of type t initialized with the given dimensions.
*)
let create ~x ~y ~width ~height ~value = { x; y; width; height; value }

(* CONTRACT
   Function that renders the brick on the screen.
   Type: t -> unit
   Parameter: brick (t), the brick object containing position and dimensions
   Result: (unit), draws a filled rectangle representing the brick.
*)
let draw (b : t) =
  let open Graphics in
  (* On attribue une couleur selon la valeur du score *)
  let color = 
    if b.value >= 20 then rgb 255 0 0      (* Rouge *)
    else if b.value >= 15 then rgb 150 0 200 (* Violet *)
    else if b.value >= 10 then rgb 0 0 255   (* Bleu *)
    else rgb 0 255 0                     (* Vert *)
  in
  set_color color;
  fill_rect (int_of_float b.x) (int_of_float b.y) (int_of_float b.width) (int_of_float b.height);
  set_color black;
  draw_rect (int_of_float b.x) (int_of_float b.y) (int_of_float b.width) (int_of_float b.height)