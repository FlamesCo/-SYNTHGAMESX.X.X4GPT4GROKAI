import pygame
from pygame.locals import *
import random

# Initialize Pygame
pygame.init()

# Set the width and height of the screen [width, height]
size = (800, 600)
screen = pygame.display.set_mode(size)
pygame.display.set_caption("Breakout")

# Main program loop initialization
done = False
clock = pygame.time.Clock()

# Define some colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)

# Ball properties
ball_speed_x = 4.0
ball_speed_y = -4.0
ball_x = size[0] / 2
ball_y = size[1] / 2
ball_size = 10.0

# Paddle properties
paddle_x = size[0] / 2
paddle_y = size[1] - 50
paddle_width = 100.0
paddle_height = 10.0
paddle_move_speed = 6.0
paddle_move = 0

# Brick properties
brick_width = 50
brick_height = 20
brick_columns = 8
brick_rows = 5
brick_spacing = 5

# Calculate total width of bricks and spaces
total_bricks_width = brick_columns * (brick_width + brick_spacing) - brick_spacing

# Calculate starting x-coordinate for the first brick to center the layout
start_x = (size[0] - total_bricks_width) / 2

# Create bricks
bricks = []
for i in range(brick_columns):
    for j in range(brick_rows):
        x = start_x + i * (brick_width + brick_spacing)
        y = 50 + j * (brick_height + brick_spacing)
        bricks.append(pygame.Rect(x, y, brick_width, brick_height))

# Main program loop
while not done:
    # Event Processing
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True
        elif event.type == KEYDOWN:
            if event.key == K_LEFT:
                paddle_move = -paddle_move_speed
            elif event.key == K_RIGHT:
                paddle_move = paddle_move_speed
        elif event.type == KEYUP:
            if event.key == K_LEFT or event.key == K_RIGHT:
                paddle_move = 0

    # Game Logic
    paddle_x += paddle_move
    paddle_x = max(0, min(paddle_x, size[0] - paddle_width))
    ball_x += ball_speed_x
    ball_y += ball_speed_y
    if ball_x < 0 or ball_x > size[0] - ball_size:
        ball_speed_x = -ball_speed_x
    if ball_y < 0:
        ball_speed_y = -ball_speed_y
    if pygame.Rect(paddle_x, paddle_y, paddle_width, paddle_height).colliderect(ball_x, ball_y, ball_size, ball_size):
        ball_speed_y = -ball_speed_y
    for brick in bricks:
        if brick.colliderect(ball_x, ball_y, ball_size, ball_size):
            ball_speed_y = -ball_speed_y
            bricks.remove(brick)
            break
    if ball_y > size[1]:
        done = True

    # Drawing
    screen.fill(BLACK)
    pygame.draw.rect(screen, GREEN, pygame.Rect(paddle_x, paddle_y, paddle_width, paddle_height))
    pygame.draw.circle(screen, RED, (int(ball_x), int(ball_y)), ball_size)
    for brick in bricks:
        pygame.draw.rect(screen, BLUE, brick)

    # Update the screen
    pygame.display.flip()
    clock.tick(60)

# Close the window and quit
pygame.quit()
