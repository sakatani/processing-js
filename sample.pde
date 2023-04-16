void setup() {
    size(600, 600, P3D);
    noLoop();
}

void draw() {
    background(0);
    lights();
    translate(width/2, height/2, 0);
    rotateY(radians(-30));
    rotateX(radians(-30));
    box(100);
}
