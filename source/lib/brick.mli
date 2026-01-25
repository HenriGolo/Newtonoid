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
val create : x:float -> y:float -> width:float -> height:float -> value:int -> t

(* CONTRACT
   Function that renders the brick on the screen.
   Type: t -> unit
   Parameter: brick (t), the brick object containing position and dimensions
   Result: (unit), draws a filled rectangle representing the brick.
*)
val draw : t -> unit