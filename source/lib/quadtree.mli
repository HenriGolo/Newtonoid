(** Structure defining the spatial boundaries of a node or a search area. *)
type borders = {
  x : float;      (** x-coordinate of the bottom-left corner of the border. *)
  y : float;      (** y-coordinate of the bottom-left corner of the border. *)
  width : float;  
  height : float; 
}

(** Type representing the Quadtree. *)
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

(** Maximum number of bricks a leaf can contain before splitting. *)
val max_in_leaf : int

(** CONTRACT
    Creates a border record defining a rectangular zone.
    Type: x:float -> y:float -> width:float -> height:float -> borders
    Parameter: x (float), the x-coordinate of the origin.
    Parameter: y (float), the y-coordinate of the origin.
    Parameter: width (float), the horizontal range.
    Parameter: height (float), the vertical range.
    Return: (borders), An initialized borders structure. *)
val create_borders : x:float -> y:float -> width:float -> height:float -> borders

(** CONTRACT
    Initializes an empty Quadtree (Nil) covering a specific area.
    Type: borders -> t
    Parameter: b (borders), the total area covered by the tree.
    Return: An empty Quadtree. *)
val create : borders -> t

(** CONTRACT
    Checks if a brick's center is contained within specific boundaries.
    Type: borders -> Brick.t -> bool
    Parameter: b (borders), the area to check against.
    Parameter: brick (Brick.t), the brick to test.
    Return: true if the brick's center is within the zone, false otherwise. *)
val contains : borders -> Brick.t -> bool

(** CONTRACT
    Splits a rectangular area into four equal quadrants.
    Type: borders -> borders * borders * borders * borders
    Parameter: b (borders), the parent area to divide.
    Return: A quadruplet (nw, ne, sw, se) of the new areas. *)
val split : borders -> borders * borders * borders * borders

(** CONTRACT
    Retrieves the spatial boundaries associated with any Quadtree node.
    Type: t -> borders
    Parameter: qt (t), a node, a leaf, or an empty tree.
    Return: The borders structure of that node. *)
val get_borders : t -> borders

(** CONTRACT
    Inserts a brick into the tree. Splits the leaf if max_in_leaf is exceeded.
    Type: t -> Brick.t -> t
    Parameter: qt (t), the current tree.
    Parameter: brick (Brick.t), the brick to insert.
    Return: (t), A new tree containing the added brick. *)
val insert : t -> Brick.t -> t

(** CONTRACT
    Checks if two rectangular zones overlap.
    Type: borders -> borders -> bool
    Parameter: b1 (borders), the first area.
    Parameter: b2 (borders), the second area.
    Return: (bool), true if there is any overlap, false otherwise. *)
val intersect : borders -> borders -> bool

(** CONTRACT
    Retrieves all bricks located within a specific search area.
    Type: t -> borders -> Brick.t list
    Parameter: qt (t), the tree to query.
    Parameter: area (borders), the search area.
    Return: (Brick.t list), A list of bricks intersecting the search area. *)
val query : t -> borders -> Brick.t list

(** CONTRACT
    Traverses the tree and calls the drawing function for every brick found.
    Type: t -> unit
    Parameter: qt (t), the tree to render.
    Return: (unit) *)
val draw_tree : t -> unit

(** CONTRACT
    Removes a specific brick from the tree and simplifies the structure if needed.
    Type: t -> Brick.t -> t
    Parameter: qt (t), the tree.
    Parameter: brick (Brick.t), the brick to remove.
    Return: (t), A new Quadtree updated without the brick. *)
val remove : t -> Brick.t -> t

(** CONTRACT
    Calculates the total number of bricks stored in the Quadtree.
    Type: t -> int
    Parameter: qt (t), the tree to analyze.
    Return: (int), the count of bricks. *)
val count_bricks : t -> int