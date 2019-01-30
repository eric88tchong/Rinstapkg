library(hexSticker)
library(tidyverse)
library(viridisLite)
library(sp)
library(png)
library(ggimage)
library(grid)
library(showtext)
font_add_google("Berkshire Swash")
font_add_google("Roboto")
showtext_auto()

# Create a raster color image with Instagram gradient colors, then save off the 
# raster and use it as the image background for the sticker.
# the putting image as background using code from:
#   https://stackoverflow.com/questions/28206611/adding-custom-image-to-geom-polygon-fill-in-ggplot

# create background ------------------------------------------------------------
grad = viridis(n=50, alpha = 1, begin = 0, end = 1, direction = 1, option = "C")
g <- ggplot() + annotation_custom(rasterGrob(grad, width = unit(1, "npc"), height = unit(1, "npc")))
ggsave('man/figures/ig-color-background.png', width=4, height=4)

# function to convert raster image to plottable data.frame ---------------------
ggplot_rasterdf <- function(color_matrix, bottom = 0, top = 1, left = 0, right = 1) {

  if (dim(color_matrix)[3] > 3) hasalpha <- T else hasalpha <- F
  
  outMatrix <- matrix("#00000000", nrow = dim(color_matrix)[1], ncol = dim(color_matrix)[2])
  
  for (i in 1:dim(color_matrix)[1])
    for (j in 1:dim(color_matrix)[2]) 
      outMatrix[i, j] <- rgb(color_matrix[i,j,1], color_matrix[i,j,2], color_matrix[i,j,3], ifelse(hasalpha, color_matrix[i,j,4], 1))
  
  colnames(outMatrix) <- seq(1, ncol(outMatrix))
  rownames(outMatrix) <- seq(1, nrow(outMatrix))
  as.data.frame(outMatrix) %>% mutate(Y = nrow(outMatrix):1) %>% 
    gather(X, color, -Y) %>% mutate(X = left + as.integer(as.character(X))*(right-left)/ncol(outMatrix), Y = bottom + Y*(top-bottom)/nrow(outMatrix))
}

# function to add the image as a background cropped into hex shape -------------
sticker_w_bg <- function(bg, subplot, 
                         s_x = 0.8, s_y = 0.75, s_width = 0.4, s_height = 0.5, 
                         package, p_x = 1, p_y = 1.4, p_color = "#FFFFFF", p_family = "Aller_Rg", 
                         p_size = 8, h_size = 1.2, h_fill = "#1881C2", h_color = "#87B13F", 
                         spotlight = FALSE, l_x = 1, l_y = 0.5, l_width = 3, l_height = 3, 
                         l_alpha = 0.4, url = "", u_x = 1, u_y = 0.08, u_color = "black", 
                         u_family = "Aller_Rg", u_size = 1.5, filename = paste0(package, ".png"), asp = 1, dpi = 300){
  
  hexd <- data.frame(x = 1 + c(rep(-sqrt(3)/2, 2), 0, 
                               rep(sqrt(3)/2, 2), 0), 
                     y = 1 + c(0.5, -0.5, -1, -0.5, 0.5, 1))
  hexd <- rbind(hexd, hexd[1, ])
  
  pic_bg <- readPNG(bg)
  suppressWarnings(
    pic_bg_dat <- ggplot_rasterdf(pic_bg, 
                                  left = min(hexd$x), right = max(hexd$x),
                                  bottom = min(hexd$y), top = max(hexd$y))
  )
  gr_hex_df <- pic_bg_dat[point.in.polygon(pic_bg_dat$X, pic_bg_dat$Y, 
                                           hexd$x, hexd$y) %>% as.logical,]
  
  sticker <- ggplot() + 
    geom_tile(data = gr_hex_df, aes(x = X, y = Y), fill = gr_hex_df$color) + 
    geom_polygon(aes_(x = ~x, y = ~y), data = hexd, size = h_size, 
                 fill="transparent", 
                 color = h_color) + 
    theme_sticker(h_size)
  
  d <- data.frame(x=s_x, y=s_y, image=subplot)
  sticker <- sticker + geom_image(aes_(x=~x, y=~y, image=~image), d, size=s_width, asp=asp)
  sticker <- sticker + geom_pkgname(package, p_x, p_y, p_color, p_family, p_size)
  sticker <- sticker + geom_url(url, x = u_x, y = u_y, color = u_color, family = u_family, size = u_size)
  save_sticker(filename, sticker, dpi = dpi)
  invisible(sticker)
}

# the cropping is not perfect and leaves some whitespace inside, so we need to 
# set the h_size to at least a value of 1.8 to not make it look awkward
# TODO: Further investigate the clipping from ggplot_rasterdf()
sticker_w_bg(bg = "man/figures/ig-color-background.png", 
             subplot = "man/figures/camera.png",
             package = "Rinstapkg", 
             s_x = 1, s_y = .75, s_width = .4, s_height = .1,
             p_size = 7, p_color = "white", p_family = "Berkshire Swash",
             h_size = 1.8, h_color = "white",
             url = "https://eric88tchong.github.io/Rinstapkg/",
             u_size = 1.1, u_color = "black", u_family = "Roboto",
             filename = "man/figures/Rinstapkg2.png")
