const gulp = require( 'gulp' )
const postcss = require( 'gulp-postcss' )
const tailwindcss = require( 'tailwindcss' )
const autoprefixer = require( 'autoprefixer' )

const PATHS = {
  css: './src/styles.css',
  config: './tailwind.js',
  dist: './'
}

gulp.task( 'css', _ => {
  return gulp.src( PATHS.css )
    .pipe( postcss( [
      tailwindcss( PATHS.config ),
      autoprefixer
    ] ) )
    .pipe( gulp.dest( PATHS.dist ) )
} )
