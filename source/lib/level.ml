let level1 () =
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

let level2 () =
  let rows = 6 in
  let cols = 10 in
  let brick_w = 70. in
  let brick_h = 20. in
  let offset_x = 35. in
  let offset_y = 200. in

  let bricks_list =List.concat (
    List.init rows (fun r ->
      List.init cols (fun c ->
        Brick.create
          ~x:(offset_x +. float c *. brick_w)
          ~y:(offset_y +. 1.5 *. float r *. brick_h)
          ~width:brick_w
          ~height:brick_h
          ~value:((r+1) * 10)
          )
      )
    )
  in
  let world_borders = Quadtree.create_borders ~x:0. ~y:0. ~width:Config.screen_w ~height:Config.screen_h in
  let empty_tree = Quadtree.create world_borders in
  List.fold_left Quadtree.insert empty_tree bricks_list

let level3 () =
  let rows = 5 in
  let cols = 8 in
  let brick_w = 90. in
  let brick_h = 25. in
  let offset_x = 30. in
  let offset_y = 250. in

  let bricks_list =List.concat (
    List.init rows (fun r ->
      List.init cols (fun c ->
        Brick.create
          ~x:(offset_x +. float c *. brick_w)
          ~y:(offset_y +. 2.2 *. float r *. brick_h)
          ~width:brick_w
          ~height:brick_h
          ~value:((r+1) * 15)
          )
      )
    )
  in
  let world_borders = Quadtree.create_borders ~x:0. ~y:0. ~width:Config.screen_w ~height:Config.screen_h in
  let empty_tree = Quadtree.create world_borders in
  List.fold_left Quadtree.insert empty_tree bricks_list

(* CONTRAT
  Function that manages the level generation.
  Type : unit -> Quadtree.t
  Return : a quadtree containing the bricks that compose the level
*)
let create_level () = (* random between level 1 and level 3 *)
  let () = Random.self_init () in
  let level_num = Random.int 3 + 1 in
  match level_num with
  | 1 -> level1 ()
  | 2 -> level2 ()
  | 3 -> level3 ()
  | _ -> level1 ()