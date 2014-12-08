var gulp = require('gulp');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var watch = require('gulp-watch');

gulp.task('default', ['watch'], function() {
});

gulp.task('sass', function() {
  gulp.src('scss/*.scss').pipe(sass()).pipe(gulp.dest('css'));
});

gulp.task('coffee', function() {
  gulp.src('coffee/*.coffee').pipe(coffee()).pipe(gulp.dest('js'));
});

gulp.task('watch', function() {
  gulp.watch('scss/*.scss', ['sass']);
  gulp.watch('coffee/*.coffee', ['coffee']);
});
