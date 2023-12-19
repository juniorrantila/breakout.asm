#pragma once
#include "window.inc"
#include "paddle.inc"

.equ BALL_WIDTH, 10
.equ BALL_HEIGHT, BALL_WIDTH

.equ BALL_START_X, (WINDOW_WIDTH / 2) - (BALL_WIDTH / 2)
.equ BALL_START_Y, PADDLE_Y - PADDLE_HEIGHT
