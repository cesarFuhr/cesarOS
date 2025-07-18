/*
 * Copyright 2021 Quentin LEBASTARD <qlebastard@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

    [0] = LAYOUT_split_3x6_3(
        //,-----------------------------------------------------.                    ,-----------------------------------------------------.
        /**/ KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T, /*                               */ KC_Y, KC_U, KC_I, KC_O, KC_P, KC_BSPC,
        //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ KC_LCTL, KC_A, KC_S, KC_D, KC_F, KC_G, /*                              */ KC_H, KC_J, KC_K, KC_L, KC_SCLN, KC_QUOT,
        //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B, /*                              */ KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_RSFT,
        //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
        /*                           */ KC_LALT, LT(2, KC_ESC), KC_LGUI, /* */ LT(3, KC_ENT), LT(1, KC_SPC), KC_RCTL
        //                                    `--------------------------'  `--------------------------'

        ),

    [1] = LAYOUT_split_3x6_3(
        //,-----------------------------------------------------.                    ,-----------------------------------------------------.
        /**/ _______, /**/ KC_1, KC_2, KC_3, /**/ KC_4, KC_5, /*                     */ KC_6, KC_7, KC_8, KC_9, KC_0, KC_BSPC,
        //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, S(KC_1), S(KC_2), S(KC_3), S(KC_4), S(KC_5), /*               */ S(KC_6), S(KC_7), S(KC_8), S(KC_9), S(KC_0), KC_BSLS,
        //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, XXXXXXX, KC_GRV, S(KC_GRV), XXXXXXX, XXXXXXX, /*              */ XXXXXXX, XXXXXXX, KC_COMM, KC_DOT, KC_SLSH, XXXXXXX,
        //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
        /*                                   */ KC_LALT, KC_ESC, KC_LGUI, /**/ KC_ENT, KC_SPC, KC_RCTL
        //                                    `--------------------------'   `--------------------------'
        ),

    [2] = LAYOUT_split_3x6_3(
        //,------------------------------------------------------.                    ,-----------------------------------------------------.
        /**/ _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, /*               */ KC_HOME, KC_PGDN, KC_RGHT, KC_END, XXXXXXX, KC_MINS,
        //|---------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, KC_LBRC, KC_RBRC, S(KC_LBRC), S(KC_RBRC), XXXXXXX, /*         */ KC_LEFT, KC_DOWN, KC_UP, KC_RIGHT, KC_PSCR, KC_EQL,
        //|---------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, /*               */ XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        //|---------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
        /*                                 */ KC_LALT, KC_ESC, KC_LGUI, /*  */ KC_ENT, KC_SPC, KC_RCTL
        //                                    `--------------------------'  `--------------------------'
        ),

    [3] = LAYOUT_split_3x6_3(
        //,------------------------------------------------------.                    ,-----------------------------------------------------.
        /**/ KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_F6, /*                           */ KC_F7, KC_F8, KC_F9, KC_F10, KC_F11, KC_F12,
        //|----------+-------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, KC_LGUI, KC_LALT, KC_LCTL, KC_LSFT, XXXXXXX, /*               */ KC_MPRV, KC_MPLY, KC_MNXT, KC_VOLD, KC_VOLU, XXXXXXX,
        //|----------+-------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, /*               */ XXXXXXX, KC_MSTP, XXXXXXX, KC_MUTE, XXXXXXX, XXXXXXX,
        //|----------+-------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
        /*                                 */ KC_LALT, KC_ESC, KC_LGUI, /*  */ KC_ENT, KC_SPC, KC_RCTL
        //                                    `--------------------------'  `--------------------------'
        ),
    [4] = LAYOUT_split_3x6_3(
        //,------------------------------------------------------.                    ,-----------------------------------------------------.
        /**/ KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_F6, /*                           */ KC_F7, KC_F8, KC_F9, KC_F10, KC_F11, KC_F12,
        //|----------+-------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, /*               */ XXXXXXX, KC_RGUI, KC_RALT, KC_RCTL, KC_RSFT, XXXXXXX,
        //|----------+-------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        /**/ _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, /*               */ XXXXXXX, KC_MSTP, XXXXXXX, KC_MUTE, XXXXXXX, XXXXXXX,
        //|----------+-------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
        /*                                 */ KC_LALT, KC_ESC, KC_LGUI, /*  */ KC_ENT, KC_SPC, KC_RCTL
        //                                    `--------------------------'  `--------------------------'
        )};
