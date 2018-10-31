const gulp = require('gulp');
const riot = require('gulp-riot');
const concat = require('gulp-concat')
// const uglify = require('gulp-uglify')
// const rename = require('gulp-rename')
const browserSync = require('browser-sync');

gulp.task('riot', () => {
    gulp.src('src/components/*.tag')
        .pipe(riot({
            compact: true
          }))
        .pipe(concat('components_all.js'))
        // .pipe(gulp.dest('dest/components'))
        // .pipe(rename('components_all.min.js'))
        // .pipe(uglify())
        .pipe(gulp.dest('dest/components'));
});

gulp.task('process_js', () => {
    // Consider to run uglify/minify over JS files later
    gulp.src(['src/js/**/*']).pipe(gulp.dest('dest/js'));
});

gulp.task('process_css', () => {
    // Consider to run LESS/SASS/minifier processor over CSS files later
    gulp.src(['src/css/**/*']).pipe(gulp.dest('dest/css')).pipe(browserSync.stream());
});

const static_paths = ['./src/*.html', './src/*.json', './src/icon/**/*', './src/json/**/*', './src/img/**/*'];

gulp.task('copy_static', () => {
    gulp.src(['./src/*.html']).pipe(gulp.dest('dest/'));
    gulp.src(['./src/*.json']).pipe(gulp.dest('dest/'));
    gulp.src(['./src/icon/**/*']).pipe(gulp.dest('dest/icon'));
    gulp.src(['./src/json/**/*']).pipe(gulp.dest('dest/json'));
    gulp.src(['./src/img/**/*']).pipe(gulp.dest('dest/img'));
});

gulp.task('browser-sync', function () {
	browserSync.init({
		injectChanges: true,
		server: {
			baseDir: ['./dest']
		}
	});
});

gulp.task('watch', ['browser-sync'], () => {
    gulp.watch(static_paths, ['copy_static']).on('change', browserSync.reload);
    gulp.watch('./src/js/**/*', ['process_js']).on('change', browserSync.reload);
    gulp.watch('./src/components/**/*', ['riot']).on('change', browserSync.reload);
    gulp.watch('./src/css/**/*', ['process_css']);
});

gulp.task('run_dev', ['default', 'watch'], () => {
});

gulp.task('default', ['riot', 'process_css', 'process_js', 'copy_static'], () => {
});
