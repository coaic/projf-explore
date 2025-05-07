# FPGA Pong Game Implementation

This project implements a classic Pong game on an iCEBreaker FPGA board with a Lattice UP5K FPGA. The game is displayed via a 12-bit DVI Pmod at 640x480 resolution with a 60Hz refresh rate.

## Game Features

- **Classic Pong Gameplay**: A ball bounces between two paddles on opposite sides of the screen
- **Player vs AI**: The left paddle is controlled by the player using up/down buttons, while the right paddle is controlled by an AI that tracks the ball's position
- **Score Display**: Scores for both players are shown at the top corners of the screen
- **Progressive Difficulty**: The ball speed increases after every 5 successful shots, making the game more challenging as play continues
- **Win Condition**: First player to reach 4 points wins the game

## Technical Implementation

- **Display**: Generates 640x480@60Hz VGA timing signals with proper horizontal and vertical sync
- **Input Processing**: Uses debounce circuitry to clean up button inputs, preventing false triggers
- **Game State Machine**: Implements a state machine with states for NEW_GAME, POSITION, READY, PLAY, POINT, and END_GAME
- **Collision Detection**: Detects collisions between the ball and paddles or screen edges
- **Score Rendering**: Displays scores using a simple bitmap font system
- **Color Generation**: Uses 4-bit color depth for each RGB channel (12-bit color)

## Hardware Details

- The design targets the iCEBreaker board with a Lattice UP5K FPGA
- Uses a 12MHz input clock that is converted to the pixel clock needed for 640x480@60Hz
- Outputs to a DVI Pmod for display
- Takes input from three buttons: fire (to start/restart), up, and down (for paddle control)
- The synthesis flow uses Yosys for synthesis, nextpnr for place and route, and icepack for bitstream generation

## Code Structure

- **top_pong.sv**: Main module that implements the game logic, display, and input handling
- **simple_480p.sv**: Generates 640x480@60Hz VGA timing signals
- **simple_score.sv**: Implements the score display using bitmap characters
- **debounce.sv**: Cleans up button inputs to prevent false triggers
- **clock_480p.sv**: Generates the pixel clock from the 12MHz input clock

## Implementation Details

### Game Parameters
- Ball size: 8x8 pixels
- Paddle dimensions: 10x48 pixels
- Initial ball speed: 5 pixels/frame horizontally, 3 pixels/frame vertically
- Paddle speed: 3 pixels/frame
- Paddle distance from edge: 32 pixels
- Win score: 4 points

### Color Scheme
- Background: Dark blue (#137)
- Ball: Yellow (#FC0)
- Paddles: White (#FFF)
- Score: Orange (#F30)

This implementation demonstrates fundamental concepts in digital design including state machines, timing generation, and interactive graphics on an FPGA.