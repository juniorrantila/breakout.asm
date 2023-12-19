#include <SDL2/SDL.h>
#include "base.h"

sysv int sdl_poll_event(void* event) __asm__("sdl_poll_event");
int sdl_poll_event(void* event)
{
    return SDL_PollEvent(event);
}

sysv int sdl_init(u32) __asm__("sdl_init");
int sdl_init(u32 flags)
{
    return SDL_Init(flags);
}

sysv void sdl_quit(void) __asm__("sdl_quit");
void sdl_quit(void)
{
    SDL_Quit();
}

sysv void* sdl_create_window(char const* name, int x, int y, int w, int h, u32 flags) __asm__("sdl_create_window");
void* sdl_create_window(char const* name, int x, int y, int w, int h, u32 flags)
{
    return SDL_CreateWindow(name, x, y, w, h, flags);
}

sysv void sdl_destroy_window(void*) __asm__("sdl_destroy_window");
void sdl_destroy_window(void* window)
{
    SDL_DestroyWindow(window);
}

sysv void sdl_show_window(void* window) __asm__("sdl_show_window");
void sdl_show_window(void* window)
{
    SDL_ShowWindow(window);
}


sysv void* sdl_create_renderer(void* window, int index, u32 flags) __asm__("sdl_create_renderer");
void* sdl_create_renderer(void* window, int index, u32 flags)
{
    return SDL_CreateRenderer(window, index, flags);
}

sysv void sdl_destroy_renderer(void* renderer) __asm__("sdl_destroy_renderer");
void sdl_destroy_renderer(void* renderer)
{
    SDL_DestroyRenderer(renderer);
}

sysv int sdl_set_render_draw_color(void* renderer, u8 r, u8 g, u8 b, u8 a) __asm__("sdl_set_render_draw_color");
int sdl_set_render_draw_color(void* renderer, u8 r, u8 g, u8 b, u8 a)
{
    return SDL_SetRenderDrawColor(renderer, r, g, b, a);
}

sysv int sdl_render_clear(void* renderer) __asm__("sdl_render_clear");
int sdl_render_clear(void* renderer)
{
    return SDL_RenderClear(renderer);
}

sysv void sdl_render_present(void* renderer) __asm__("sdl_render_present");
void sdl_render_present(void* renderer)
{
    SDL_RenderPresent(renderer);
}

sysv int sdl_render_fill_rect(void* renderer, void* rect) __asm__("sdl_render_fill_rect");
int sdl_render_fill_rect(void* renderer, void* rect)
{
    return SDL_RenderFillRect(renderer, rect);
}

sysv u32 sdl_ticks(void) __asm__("sdl_ticks");
u32 sdl_ticks(void)
{
    return SDL_GetTicks();
} 

sysv void sdl_delay(u32 ms) __asm__("sdl_delay");
void sdl_delay(u32 ms)
{
    SDL_Delay(ms);
}

sysv char const* sdl_get_error(void) __asm__("sdl_get_error");
char const* sdl_get_error(void)
{
    return SDL_GetError();
}

sysv u8 const* sdl_keyboard_state(i32* numkeys) __asm__("sdl_keyboard_state");
u8 const* sdl_keyboard_state(i32* numkeys)
{
    return SDL_GetKeyboardState(numkeys);
}


sysv u8 sdl_has_intersection(void* a, void* b) __asm__("sdl_has_intersection");
u8 sdl_has_intersection(void* a, void* b)
{
    return SDL_HasIntersection(a, b);
}

