(* CONTRAT
   Function that manages collision detection and bounce between a ball and a brick.
   Type : Ball.t -> Brick.t -> (Ball.t * bool)
   Parameter : ball (Ball.t), current state of the ball.
   Parameter : brick (Brick.t), brick for which we want to check if there is a collision with the ball.
   Return : A couple (new_ball, collision_detected) where :
              - new_ball is the ball with a modified speed in case of a bounce, or the original ball otherwise.
              - collision_detected is a Boolean value that is true if contact has occurred.
*)
val collision : Ball.t -> Brick.t -> Ball.t * bool

(* CONTRAT
   Function that manages collision detection and bounce between a ball and the paddle.
   Type : Ball.t -> Paddle.t -> (Ball.t * bool)
   Parameter : ball (Ball.t), current state of the ball.
   Parameter : paddle (Paddle.t), paddle for which we want to check if there is a collision with the ball.
   Return : A couple (new_ball, collision_detected) where :
              - new_ball is the ball with a modified speed in case of a bounce, or the original ball otherwise.
              - collision_detected is a Boolean value that is true if contact has occurred.
*)
val ball_paddle : Ball.t -> Paddle.t -> Ball.t * bool