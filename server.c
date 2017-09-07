#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>

int main (void) {
    void* ctx = zmq_ctx_new();

    void* listener = zmq_socket(ctx, ZMQ_REP);
    void* publisher = zmq_socket(ctx, ZMQ_PULL);

    zmq_bind(listener, "tcp://*:5554");
    zmq_bind(publisher, "tcp://*:5555");

    char buf[1024];

    while (1){
        zmq_recv(listener, buf, 1024, 0);
        printf("sending: %s\n", buf);
        zmq_send(publisher, buf, strlen(buf)+1, 0);
    }

    return 0;
}
