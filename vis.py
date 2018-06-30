import time
import numpy as np
import tkinter as tk
from PIL import ImageTk, Image
import logging
import sys
import argparse

np.random.seed(1)
PhotoImage = ImageTk.PhotoImage
# UNIT = 40  # pixels
# HEIGHT = 5  # grid height
# WIDTH = 5  # grid width

IMAGE_ICON_SIZE = 25


class Env(tk.Tk):
    def __init__(self, info):
        super(Env, self).__init__()

        # Environment info
        self.env_info = info["env"]

        self.Ny = self.env_info["Ny"]
        self.Nx = self.env_info["Nx"]

        self.UNIT = 80

        if "Unit" in self.env_info:
            self.UNIT = self.env_info["Unit"]

        self.WIDTH = self.Nx
        self.HEIGHT = self.Ny
        # ********* ***********

        self.title('Penalty Solver')
        self.geometry('{0}x{1}'.format(self.WIDTH * self.UNIT, self.HEIGHT * self.UNIT))
        self.shapes = self._load_images()
        self.canvas = self._build_canvas()

        self._pack_canvas()

        self._create_elements()
        # ************* from other file ******************

    def _create_elements(self):

        CROSS_BLOCK = 3
        STATIC_BALL = 4

        # ball initial position
        resource_ball_static = self.add_item_at(2, STATIC_BALL)

        # defenders
        resource_blocked_defender_1 = self.add_item_at(11, CROSS_BLOCK)
        resource_blocked_defender_2 = self.add_item_at(12, CROSS_BLOCK)
        resource_blocked_defender_3 = self.add_item_at(13, CROSS_BLOCK)

        # goal keeper
        resource_blocked_1 = self.add_item_at(21, CROSS_BLOCK)
        resource_blocked_2 = self.add_item_at(22, CROSS_BLOCK)
        resource_blocked_3 = self.add_item_at(23, CROSS_BLOCK)

    def add_item_at(self, pos, resource_index):

        x2 = self._get_row_center_pixel(pos)
        y2 = self._get_column_center_pixel(pos)

        return self.canvas.create_image(y2, x2, image=self.shapes[resource_index])

    def add_item_at_row_col(self, row, col, resource_index):

        x = int(row*self.UNIT + self.UNIT / 2)
        y = int(col*self.UNIT + self.UNIT / 2)

        return self.canvas.create_image(y, x, image=self.shapes[resource_index])

    def _get_row(self, pos):
        return pos // self.WIDTH

    def _get_col(self, pos):
        return pos % self.WIDTH

    def _get_row_center_pixel(self, pos):
        row = self._get_row(pos)

        return int(row*self.UNIT + self.UNIT / 2)

    def _get_column_center_pixel(self, pos):
        col = self._get_col(pos)

        return int(col*self.UNIT + self.UNIT / 2)

    def _build_canvas(self):
        canvas = tk.Canvas(self, bg='white',
                           height=self.HEIGHT * self.UNIT,
                           width=self.WIDTH * self.UNIT)
        # create grids
        for c in range(0, self.WIDTH * self.UNIT, self.UNIT):  # 0~400 by 80
            x0, y0, x1, y1 = c, 0, c, self.HEIGHT * self.UNIT
            canvas.create_line(x0, y0, x1, y1)
        for r in range(0, self.HEIGHT * self.UNIT, self.UNIT):  # 0~400 by 80
            x0, y0, x1, y1 = 0, r, self.HEIGHT * self.UNIT, r
            canvas.create_line(x0, y0, x1, y1)

        return canvas

    def render(self):
        time.sleep(0.03)
        self.update()

    def _pack_canvas(self):
        self.canvas.pack()

    def _load_images(self):
        rectangle = PhotoImage(
            Image.open("img/rectangle.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))
        triangle = PhotoImage(
            Image.open("img/triangle.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))
        circle = PhotoImage(
            Image.open("img/circle.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))

        cross = PhotoImage(
            Image.open("img/cross.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))

        ball_starting_point = PhotoImage(
            Image.open("img/circle_static.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))


        return rectangle, triangle, circle, cross, ball_starting_point


    @staticmethod
    def setup_custom_logger(name, level, file_name='log.txt'):
        formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                      datefmt='%Y-%m-%d %H:%M:%S')
        handler = logging.FileHandler(file_name, mode='w')
        handler.setFormatter(formatter)
        # screen_handler = logging.StreamHandler(stream=sys.stdout)
        # screen_handler.setFormatter(formatter)
        logger = logging.getLogger(name)
        logger.setLevel(level)
        logger.addHandler(handler)
        # logger.addHandler(screen_handler)

        return logger


def get_parser():
    """Get parser for command line arguments."""
    parser = argparse.ArgumentParser(description="Tweet Downloader")
    parser.add_argument("-d",
                        "--data",
                        dest="data",
                        help="Read data from file or display initial setting",
                        default=False)

    return parser


if __name__ == "__main__":

    parser = get_parser()
    args = parser.parse_args()

    info = {
        "env": {"Ny": 5,
                "Nx": 5},
    }

    env = Env(info)

    occurs = []
    data = int(args.data)

    if data != 0:
        with open('data.txt') as filePointer:
            for line in filePointer:
                line = line.strip()
                if len(line) < 10 or line.startswith('#'):
                    continue
                occurs = line.split(' ')

                break
    for occur in occurs:
        sub = occur[(occur.rfind('(') + 1):]
        sub = sub[0:sub.find(')')]

        pos_row = sub[0:sub.find(',')]
        pos_col = sub[(sub.find(',')+1):]
        row = int(pos_row) - 1
        col = int(pos_col) - 1

        BALL = 2
        env.add_item_at_row_col(row, col, BALL)
        # break

    while True:
        env.render()