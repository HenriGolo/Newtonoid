(* ouvre la bibliotheque de modules definis dans lib/ *)
open Libnewtonoid
open Iterator

(* exemple d'ouvertue d'un tel module de la bibliotheque : *)
open Game

module Init = struct
  let dt = 1. /. 60. (* 60 Hz *)
end

module Box = struct
  let marge = 10.
  let infx = 10.
  let infy = 10.
  let supx = 790.
  let supy = 590.
end

type state = {
  ball : Ball.t;
  paddle : Paddle.t;
  bricks : Brick.t list;
  running : bool; (* Si le jeu est lancé *)
}

let initial_state =
  {
    ball = Config.ball;
    paddle = Config.paddle;
    bricks = Level.create_level ();
    running = false;
  }

(* Fonction integre vue dans le tp7 *)
let integre dt flux =
  let init = ( 0., 0.) in
  let iter (acc1, acc2) (flux1, flux2) =
    (acc1 +. dt *. flux1, acc2 +. dt *. flux2) in
  let rec acc =
    Tick (lazy (Some (init, Flux.map2 iter acc flux)))
  in acc;;

(* Calcule le mouvement de la balle en fonction du temps soumis à la gravité *)
let balle_mouvement (balle : Ball.t) =
  let ((x0, y0), (dx0, dy0)) =
    ((balle.Ball.x, balle.y), (balle.vx, balle.vy)) in
  let acc = Flux.constant (0., Config.g) in
  let vit = Flux.map (fun (dx, dy) -> (dx +. dx0, dy +. dy0)) (integre Init.dt acc) in
  let pos = Flux.map (fun (x, y) -> (x +. x0, y +. y0)) (integre Init.dt vit) in
  
  Flux.map2 (fun (x, y) (vx, vy) -> 
    { balle with x; y; vx; vy }
  ) pos vit

(* Gère les collisions entre la balle, la raquette et les briques *)
let handle_collisions ball paddle bricks =
  (* Walls *)
  let ball =
    if ball.Ball.x < Box.infx +. ball.radius || ball.x > Box.supx -. ball.radius
    then Ball.bounce_x ball else ball
  in
  let ball =
    if ball.y > Box.supy -. ball.radius 
    then Ball.bounce_y ball else ball
    (* si < y à gérer *)
  in

  (* Paddle *)
  let (ball, _hit_paddle) = Collision.ball_paddle ball paddle in

  (* Bricks : à modifier comme donnée dans le sujet pour pas check la collision avec toutes les briques *)
  let new_bricks, ball = List.fold_left (fun (acc_bricks, b) brick ->
        let (new_ball, has_hit) = Collision.collision b brick in
        if has_hit then 
          (acc_bricks, new_ball)
        else 
          (brick :: acc_bricks, b) (* On garde la brique que si elle n'a pas été touchée *)
      ) ([], ball) bricks
  in
  (ball, new_bricks)

(* Met à jour l'état du système *)
let update_state (mouse_x, click) state =
  let dt = Init.dt in
  let paddle = { state.paddle with x = mouse_x -. state.paddle.width /. 2. } in
  let running = state.running || click in
  
  let ball =
    if not running then
      { state.ball with 
          x = paddle.x +. paddle.width /. 2.; 
          y = paddle.y +. paddle.height +. state.ball.radius +. 1. }
    else
      let flux_ball = balle_mouvement state.ball in
      let ball_nxt = match Flux.uncons flux_ball with
        | None -> state.ball
        | Some (b, _) -> b
      in  
      
      Ball.move ball_nxt dt 
  in
  let ball, bricks = handle_collisions ball paddle state.bricks in
  if ball.y < Box.infy then
      initial_state 
  else
  { state with ball; paddle; bricks; running }

(* Dessine l'état du jeu *)  
let draw_state etat =
  Paddle.draw etat.paddle;
  Ball.draw etat.ball;
  List.iter Brick.draw etat.bricks

(* Produit le flux des états successifs du jeu *)
let game_flux initial_s =
  Flux.unfold
    (fun (s, mouse_flux) ->
       match Flux.uncons mouse_flux with
       | None -> None
       | Some (mouse, mf') ->
           let s' = update_state mouse s in
           Some (s', (s', mf')))
    (initial_s, Input.mouse)

(* extrait le score courant d'un etat : *)
let score etat : int = 0 (* A completer plus tard *)

let graphic_format =
  Format.sprintf
    " %dx%d+50+50"
    (int_of_float ((2. *. Box.marge) +. Box.supx -. Box.infx))
    (int_of_float ((2. *. Box.marge) +. Box.supy -. Box.infy))

let draw flux_etat =
  let rec loop flux_etat last_score =
    match Flux.(uncons flux_etat) with
    | None -> last_score
    | Some (etat, flux_etat') ->
      Graphics.clear_graph ();
      (* DESSIN ETAT *)
      draw_state etat;
      (* FIN DESSIN ETAT *)
      Graphics.synchronize ();
      Unix.sleepf Init.dt;
      loop flux_etat' (last_score + score etat)
    | _ -> assert false
  in
  Graphics.open_graph graphic_format;
  Graphics.auto_synchronize false;
  let score = loop flux_etat 0 in
  Format.printf "Score final : %d@\n" score;
  Graphics.close_graph ()

let () = print_endline "Hello, Newtonoiders!";
  draw (game_flux initial_state)
