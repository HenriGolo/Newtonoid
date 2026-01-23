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
  score : int;
  lives : int;
}

let initial_state =
  {
    ball = Config.ball;
    paddle = Config.paddle;
    bricks = Level.create_level ();
    running = false;
    score = 0;
    lives = 3;
  }

(* CONTRAT
    Function that numerically integrates a 2D flux (vector) over time.
    Type : float -> (float * float) Flux.t -> (float * float) Flux.t
    Parameter : dt (float), the time step for the integration.
    Parameter : flux ((float * float) Flux.t), a stream of 2D vectors we want to integrate.
    Return : A stream of pairs representing the cumulative integral (acc1, acc2) at each step.
*)
(* Fonction integre vue dans le tp7 *)
let integre dt flux =
  let init = ( 0., 0.) in
  let iter (acc1, acc2) (flux1, flux2) =
    (acc1 +. dt *. flux1, acc2 +. dt *. flux2) in
  let rec acc =
    Tick (lazy (Some (init, Flux.map2 iter acc flux)))
  in acc;;


(* CONTRAT
    Calculates the movement of the ball over time subject to constant gravity.
    Type : Ball.t -> Ball.t Flux.t
    Parameter : balle (Ball.t), the initial state of the ball (position and speed).
    Return : A stream of Ball.t representing the ball's trajectory and physical state at each time step.
*)
let balle_mouvement (balle : Ball.t) =
  let ((x0, y0), (dx0, dy0)) =
    ((balle.Ball.x, balle.y), (balle.vx, balle.vy)) in
  let acc = Flux.constant (0., Config.g) in
  let vit = Flux.map (fun (dx, dy) -> (dx +. dx0, dy +. dy0)) (integre Init.dt acc) in
  let pos = Flux.map (fun (x, y) -> (x +. x0, y +. y0)) (integre Init.dt vit) in
  
  Flux.map2 (fun (x, y) (vx, vy) -> 
    { balle with x; y; vx; vy }
  ) pos vit


(* CONTRAT
    This Function manages collisions between the ball, window boundaries, the paddle, and the bricks.
    Type : Ball.t -> Paddle.t -> Brick.t list -> (Ball.t * Brick.t list * int)
    Parameter : ball (Ball.t), current state of the ball.
    Parameter : paddle (Paddle.t), current state of the paddle.
    Parameter : bricks (Brick.t list), the list of bricks the ball can collide with.
    Return : ball is the updated ball state after potential bounces and speed capping.
             new_bricks is the updated list of bricks (excluding those destroyed).
             points_gagnes is the total score accumulated during this update step.
*)
let handle_collisions ball paddle bricks =
  let hit_horizontal_wall = 
    ball.Ball.x < Box.infx +. ball.radius || ball.x > Box.supx -. ball.radius in
  let hit_vertical_wall = 
    ball.y +. ball.radius > Box.supy in

  (* Walls *)
  let ball =
    if hit_horizontal_wall
    then Ball.bounce_x ball else ball
  in
  let ball =
    if hit_vertical_wall
    then Ball.bounce_y ball else ball
    (* si < y à gérer *)
  in

  (* Paddle *)
  let (ball, hit_paddle) = Collision.ball_paddle ball paddle in

  (* Bricks : à modifier comme donnée dans le sujet pour pas check la collision avec toutes les briques *)
  let old_count = List.length bricks in
  let new_bricks, ball, points_gagnes = List.fold_left (fun (acc_bricks, b, pts) brick ->
        let (new_ball, has_hit) = Collision.collision b brick in
        if has_hit then 
          (acc_bricks, new_ball, pts + brick.Brick.value)
        else 
          (brick :: acc_bricks, b, pts)
      ) ([], ball, 0) bricks
  in
 
  let hit_brick = points_gagnes > 0 in
  let ball = if hit_brick || hit_vertical_wall || hit_horizontal_wall || hit_paddle then
      Ball.cap_speed(Ball.accelerate Config.bounce_accel ball) Config.max_speed
    else ball
  in
  (ball, new_bricks, points_gagnes)

(* CONTRAT
    Updates the entire game state for a single frame based on user input and physics.
    Type : (float * bool) -> state -> state
    Parameter : (mouse_x, click) (float * bool), the current X position of the mouse and the click status.
    Parameter : state (state), the current global state of the game.
    Return : The new game state (updated paddle, ball position, bricks, lives, and score).
*)
let update_state (mouse_x, click) state =
  let dt = Init.dt in
  let new_x = mouse_x -. state.paddle.width /. 2. in
  (* Calcul de la vitesse de la raquette *)
  let paddle_vx = (new_x -. state.paddle.x) /. dt in
  let paddle = { state.paddle with x = new_x; vx = paddle_vx } in
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
  let ball, bricks, hits = handle_collisions ball paddle state.bricks in
  let ball_final = Ball.cap_speed ball Config.max_speed in
  let new_score = state.score + hits in
  if ball.y < Box.infy then
    (* reset avec une vie en moins *)
    { state with 
        lives = state.lives - 1; 
        running = false;
        ball = Config.ball;
    }
  else
  { state with ball = ball_final; paddle; bricks; running; score = new_score }

(* CONTRAT
    Renders the current game state to the graphical window.
    Type : state -> unit
    Parameter : etat (state), the current state to be drawn.
    Return : (unit). Clears the screen and draws the paddle, ball, bricks, and UI (score ...).
*)
let draw_state etat =
  Paddle.draw etat.paddle;
  Ball.draw etat.ball;
  List.iter Brick.draw etat.bricks;
  (* mettre à jour avec des variables globales*)
  Graphics.set_color Graphics.black;
  Graphics.moveto 20 570;
  Graphics.draw_string (Printf.sprintf "Score: %d | Vies: %d" etat.score etat.lives)

(* CONTRAT
    Produces an infinite stream of successive game states starting from an initial state.
    Type : state -> state Flux.t
    Parameter : initial_s (state), the starting state of the game.
    Return : A stream (Flux.t) of states generated by applying update_state to each mouse input.
*)
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
let score etat : int = etat.score

let graphic_format =
  Format.sprintf
    " %dx%d+50+50"
    (int_of_float ((2. *. Box.marge) +. Box.supx -. Box.infx))
    (int_of_float ((2. *. Box.marge) +. Box.supy -. Box.infy))

(* CONTRAT
    The main execution loop that consumes the state flux and manages the display of the window.
    Type : state Flux.t -> unit
    Parameter : flux_etat (state Flux.t), the stream of game states to render.
    Return : (unit), Opens the window, runs the animation loop, and prints the final score.
*)
let draw flux_etat =
  let rec loop flux_etat last_score =
    match Flux.(uncons flux_etat) with
    | None -> last_score
    | Some (etat, flux_etat') ->
      if etat.lives <= 0 then begin
        Graphics.clear_graph ();
        Graphics.moveto (int_of_float (Box.supx /. 2.)) (int_of_float (Box.supy /. 2.));
        Graphics.draw_string "GAME OVER";
        Graphics.synchronize ();
        Unix.sleepf 2.0;
        last_score
      end else begin
        Graphics.clear_graph ();
        draw_state etat;
        Graphics.synchronize ();
        Unix.sleepf Init.dt;
        loop flux_etat' (score etat)
      end
    | _ -> assert false
  in
  Graphics.open_graph graphic_format;
  Graphics.auto_synchronize false;
  let score = loop flux_etat 0 in
  Format.printf "Score final : %d@\n" score;
  Graphics.close_graph ()

let () = print_endline "Hello, Newtonoiders!";
  draw (game_flux initial_state)
