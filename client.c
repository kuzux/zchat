#include <zmq.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>

int main (void) {
    void* ctx = zmq_ctx_new();

    void* sender = zmq_socket(ctx, ZMQ_PUSH);
    void* listener = zmq_socket(ctx, ZMQ_SUB);
    
    zmq_connect(sender, "tcp://localhost:5554");
    zmq_connect(listener, "tcp://localhost:5555");

    zmq_send(sender, "joined", 7, 0);

    printf("%s\n", "sent");

    char buf[1024];

    while(1){
        zmq_recv(listener, buf, 1024, 0);
        printf("%s\n", buf);
    }

    zmq_close(sender);
    zmq_close(listener);

    zmq_ctx_destroy(ctx);
    return 0;
}

