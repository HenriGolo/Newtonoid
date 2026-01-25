(* Interface pour le quadtree *)

type borders = {
  x : float;
  y : float;
  width : float;
  height : float;
}

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

val max_in_leaf : int

val create_borders : x:float -> y:float -> width:float -> height:float -> borders

val create : borders -> t

val contains : borders -> Brick.t -> bool

val split : borders -> borders * borders * borders * borders

val get_borders : t -> borders

val insert : t -> Brick.t -> t

val intersect : borders -> borders -> bool

val query : t -> borders -> Brick.t list

val draw_tree : t -> unit

val remove : t -> Brick.t -> t

(* Compte le nombre de briques dans l'arbre *)
val count_bricks : t -> int