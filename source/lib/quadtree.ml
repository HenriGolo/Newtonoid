type borders = {
  x : float;
  y : float;
  width : float;
  height : float;
}

(* Q Tree *)
type t = 
  | Nil of borders
  | Leaf of borders * Brick.t list
  | Node of {
      nw : t;
      ne : t;
      sw : t;
      se : t;
      bounds : borders;
    }

let create_borders ~x ~y ~width ~height : borders =
  { x; y; width; height }

let create (b: borders) : t =
  Nil b

(* Verifie que la brique brick est dans les bords b *)
let contains (b: borders) (brick : Brick.t) : bool =
  let mid_x = brick.x +. (brick.width /. 2.) in
  let mid_y = brick.y +. (brick.height /. 2.) in
  mid_x >= b.x && mid_x < b.x +. b.width &&
  mid_y >= b.y && mid_y < b.y +. b.height

let split (b: borders) : borders * borders * borders * borders =
  let half_width = b.width /. 2. in
  let half_height = b.height /. 2. in
  let nw = { x = b.x; y = b.y; width = half_width; height = half_height } in
  let ne = { x = b.x +. half_width; y = b.y; width = half_width; height = half_height } in
  let sw = { x = b.x; y = b.y +. half_height; width = half_width; height = half_height } in
  let se = { x = b.x +. half_width; y = b.y +. half_height; width = half_width; height = half_height } in
  (nw, ne, sw, se)

let get_borders = function
  | Nil b | Leaf (b, _) | Node { bounds = b; _ } -> b

(* Insertion d'une brique dans l'arbre *)  
let rec insert (qt: t) (brick: Brick.t) : t =
  let b = get_borders qt in
  if not (contains b brick) 
    then qt
  else
    match qt with
    | Nil b -> Leaf (b, [brick])
    | Leaf (b, bricks) -> 
        if List.length bricks < Config.max_in_leaf then
          Leaf (b, brick :: bricks)
        else
          (* on transforme la feuille en un noeud et on répartit les briques *)
          let (nw, ne, sw, se) = split b in
          let node = Node { nw = Nil nw; ne = Nil ne; sw = Nil sw; se = Nil se; bounds = b } in
          List.fold_left (fun t br -> insert t br) node (brick :: bricks)
    | Node n -> 
        Node {n with
          nw = insert n.nw brick;
          ne = insert n.ne brick;
          sw = insert n.sw brick;
          se = insert n.se brick;
        }

let intersect (b1: borders) (b2: borders) : bool =
  not (b1.x > b2.x +. b2.width || b1.x +. b1.width < b2.x ||
       b1.y > b2.y +. b2.height || b1.y +. b1.height < b2.y)

(* Recherche des briques autour de la balle *)
let rec query (qt: t) (area: borders) : Brick.t list =
  let b = get_borders qt in
  if not (intersect b area) then
    []
  else
    match qt with
    | Nil _ -> []
    | Leaf (_, bricks) -> List.filter (fun (brick : Brick.t) -> 
          let brick_box = { 
            x = brick.x; 
            y = brick.y; 
            width = brick.width; 
            height = brick.height 
          } in
          intersect area brick_box
        ) bricks
    | Node n ->
        let bricks_nw = query n.nw area in
        let bricks_ne = query n.ne area in
        let bricks_sw = query n.sw area in
        let bricks_se = query n.se area in
        bricks_nw @ bricks_ne @ bricks_sw @ bricks_se

let draw_tree qt =
  let rec aux = function
    | Nil _ -> ()
    | Leaf (_, bricks) -> List.iter Brick.draw bricks
    | Node n ->
        aux n.nw;
        aux n.ne;
        aux n.sw;
        aux n.se;
  in
  aux qt

(* Suppression d'une brique de l'arbre *)
let rec remove (qt: t) (brick: Brick.t) : t =
  let b = get_borders qt in
  if not (contains b brick)
    then qt
  else
    match qt with
    | Nil _ -> qt
    | Leaf (b, bricks) ->
        let new_bricks = List.filter (fun br -> br <> brick) bricks in
        if new_bricks = [] then Nil b
        else Leaf (b, new_bricks)
    | Node n ->
        let nw' = remove n.nw brick in
        let ne' = remove n.ne brick in
        let sw' = remove n.sw brick in
        let se' = remove n.se brick in
        if nw' = Nil (get_borders n.nw) && ne' = Nil (get_borders n.ne) && 
           sw' = Nil (get_borders n.sw) && se' = Nil (get_borders n.se) 
        then Nil n.bounds
        else Node { n with nw = nw'; ne = ne'; sw = sw'; se = se' }


let count_bricks (qt: t) : int =
  let rec aux = function
    | Nil _ -> 0
    | Leaf (_, bricks) -> List.length bricks
    | Node n ->
        aux n.nw + aux n.ne + aux n.sw + aux n.se
  in
  aux qt