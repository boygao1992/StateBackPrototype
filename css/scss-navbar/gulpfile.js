const gulp = require( "gulp" )
const sass = require( "gulp-sass" )
const browserSync = require( "browser-sync" )

const TASK_SASS = "sass"
const TASK_BROWSER_SYNC = "browser-sync"
const TASK_DEFAULT = "default"

gulp.task( TASK_SASS, () => {
  gulp.src( "scss/index.scss" )
    .pipe( sass( { includePaths: [ "scss" ] } ) )
    .pipe( gulp.dest( "css" ) )
} )

gulp.task( TASK_BROWSER_SYNC, () => {
  browserSync.init( [ "css/*.css", "index.html" ], {
    server: {
      baseDir: "./"
    }
  } )
} )

gulp.task( TASK_DEFAULT, [ TASK_SASS, TASK_BROWSER_SYNC ], () => {
  gulp.watch( "scss/*.scss", [ TASK_SASS ] )
} )
