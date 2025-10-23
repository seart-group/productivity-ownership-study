import curses
import random
import time
from enum import Enum
from dataclasses import dataclass

GRID_WIDTH = 50
GRID_HEIGHT = 20
BORDER_CHAR = '*'
FOOD_CHAR = '#'
SNAKE_CHAR = 'o'

@dataclass(frozen=True)
class Position:
    x: int
    y: int

class Direction(Enum):
    UP = (0, -1)
    DOWN = (0, 1)
    LEFT = (-1, 0)
    RIGHT = (1, 0)

class SnakeGame:
    def __init__(self, stdscr):
        self.stdscr = stdscr
        self.init_curses()
        self.check_terminal_size()
        self.snake = [Position(10, 5), Position(9, 5), Position(8, 5)]
        self.direction = Direction.RIGHT
        self.food = self.spawn_food()
    
    def init_curses(self):
        curses.curs_set(0)
        self.stdscr.nodelay(True)
        self.stdscr.timeout(66)  # ~15 FPS
    
    def check_terminal_size(self):
        term_height, term_width = self.stdscr.getmaxyx()
        if term_height < GRID_HEIGHT or term_width < GRID_WIDTH:
            self.stdscr.clear()
            msg = (f"Terminal too small! Need at least {GRID_HEIGHT}x{GRID_WIDTH}.\n"
                   "Increase terminal size or modify variables GRID_HEIGHT and GRID_WIDTH.")
            # Center message
            msg_y = term_height // 2
            msg_x = max(0, (term_width - len(msg)) // 2)
            self.stdscr.addstr(msg_y, msg_x, msg)
            self.stdscr.refresh()
            time.sleep(2)
            curses.endwin()
            exit(1)
    
    def spawn_food(self):
        while True:
            pos = Position(random.randint(1, GRID_WIDTH - 2), random.randint(1, GRID_HEIGHT - 2))
            if pos not in self.snake:
                return pos
    
    def check_collisions(self):
        head = self.snake[0]
        if head.x in {0, GRID_WIDTH - 1} or head.y in {0, GRID_HEIGHT - 1}:
            return False
        return len(set(self.snake)) == len(self.snake)
    
    def process_input(self):
        key = self.stdscr.getch()
        key_map = {
            curses.KEY_UP: Direction.UP,
            curses.KEY_DOWN: Direction.DOWN,
            curses.KEY_LEFT: Direction.LEFT,
            curses.KEY_RIGHT: Direction.RIGHT,
        }
        new_direction = key_map.get(key, self.direction)
        if (new_direction.value[0] + self.direction.value[0], new_direction.value[1] + self.direction.value[1]) != (0, 0):
            self.direction = new_direction
    
    def update_snake(self):
        head = self.snake[0]
        new_head = Position(head.x + self.direction.value[0], head.y + self.direction.value[1])
        self.snake.insert(0, new_head)
        if new_head == self.food:
            self.food = self.spawn_food()
        else:
            self.snake.pop()
    
    def draw(self):
        self.stdscr.clear()
        # Draw borders
        for x in range(GRID_WIDTH):
            self.stdscr.addch(0, x, BORDER_CHAR)
            self.stdscr.addch(GRID_HEIGHT - 1, x, BORDER_CHAR)
        for y in range(GRID_HEIGHT):
            self.stdscr.addch(y, 0, BORDER_CHAR)
            self.stdscr.addch(y, GRID_WIDTH - 1, BORDER_CHAR)
        
        # Draw food and snake
        self.stdscr.addch(self.food.y, self.food.x, FOOD_CHAR)
        for segment in self.snake:
            self.stdscr.addch(segment.y, segment.x, SNAKE_CHAR)
        
        self.stdscr.refresh()
    
    def run(self):
        while True:
            self.process_input()
            self.update_snake()
            if not self.check_collisions():
                break
            self.draw()
            time.sleep(0.05)
        
if __name__ == '__main__':
    curses.wrapper(lambda stdscr: SnakeGame(stdscr).run())
