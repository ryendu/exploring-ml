void main()
{
    if ( u_path_length == 0.0 ) {
        gl_FragColor = vec4( 0.0, 0.0, 1.0, 1.0 );
    } else if ( v_path_distance / u_path_length <= u_current_percentage ) {
        gl_FragColor = vec4(0.411,0.915,0.898,1.0);
    } else {
        gl_FragColor = vec4( 0.0, 0.0, 0.0, 0.0 );
    }
}
