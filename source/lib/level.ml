(* CONTRAT
   Function that manages the level generation.
   Type : unit -> Brick.t List
   Return : a list of the bricks that compose the level
*)
let create_level () =
  (*example of level*)
  let rows = 4 in
  let cols = 9 in
  let brick_w = 80. in
  let brick_h = 20. in
  let offset_x = 40. in
  let offset_y = 260. in

  let bricks_list =List.concat (
    List.init rows (fun r ->
      List.init cols (fun c ->
        Brick.create
          ~x:(offset_x +. float c *. brick_w)
          ~y:(offset_y +. 2. *. float r *. brick_h)
          ~width:brick_w
          ~height:brick_h
          ~value:((r+1) * 5)
          )
      )
    )
  in
  let world_borders = Quadtree.create_borders ~x:0. ~y:0. ~width:Config.screen_w ~height:Config.screen_h in
  let empty_tree = Quadtree.create world_borders in
  List.fold_left Quadtree.insert empty_tree bricks_list