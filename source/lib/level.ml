(*example of level*)
let create_level () =
  let rows = 5 in
  let cols = 8 in
  let brick_w = 80. in
  let brick_h = 20. in
  let offset_x = 50. in
  let offset_y = 400. in

  List.concat (
    List.init rows (fun r ->
      List.init cols (fun c ->
        Brick.create
          ~x:(offset_x +. float c *. brick_w)
          ~y:(offset_y +. float r *. brick_h)
          ~width:brick_w
          ~height:brick_h)))
