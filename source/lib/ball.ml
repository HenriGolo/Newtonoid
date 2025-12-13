type t = {
  x : float;
  y : float;
  radius : float;
  vx : float;
  vy : float;
}

let create ~x ~y ~radius ~vx ~vy = { x; y; radius; vx; vy }