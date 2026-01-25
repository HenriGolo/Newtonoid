type t = {
  x : float;
  y : float;
  width : float;
  height : float;
  value : int;
}

let create ~x ~y ~width ~height ~value = { x; y; width; height; value }

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