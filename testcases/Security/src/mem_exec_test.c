#include <errno.h>
#include <signal.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

static char *buf = NULL;
static size_t sz = 0;

static void handler(int sig, siginfo_t *si, void *unused)
{
    /* Note: calling printf() from a signal handler is not safe
 *        (and should not be done in production programs), since
 *               printf() is not async-signal-safe; see signal-safety(7).
 *                      Nevertheless, we use printf() here as a simple way of
 *                             showing that the handler was called. */

    printf("Got memory exception at 0x%lx\n", (long) si->si_addr);
    if (buf != NULL && buf != MAP_FAILED)
        munmap(buf, sz);
    exit(2);
}

static void set_signal_handler(void)
{
    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction = handler;

    if (sigaction(SIGSEGV, &sa, NULL) == -1)
    {
        perror("sigaction");
        exit(1);
    }
}

static int func(void)
{
    return 123 * 456;
}

int main(int argc, char **argv)
{
    set_signal_handler();

    /* 申请内存时设置为不可执行 */
    sz = (char *)main - (char *)func;
    char *buf = mmap(NULL, sz, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

    if ((void *)buf == MAP_FAILED)
    {
        perror("mmap");
        exit(1);
    }

    printf("Allocate memory at 0x%lx\n", buf);
    memcpy(buf, func, sz);  /* 将函数func拷贝到申请的内存 */

    /* 运行时加上任意参数 将内存设为可执行 */
    if (argc > 1)
    {
        if (mprotect(buf, sz, PROT_EXEC | PROT_READ | PROT_WRITE) == -1)
        {
            perror("mprotect");
            munmap(buf, sz);
            exit(1);
        }
        printf("Set 0x%lx executable\n", buf);
    }

    int (*f)() = (void*)buf;
    int ret = f();  /* 将内存设置为不可执行时 将触发SIGSEGV */
    printf("Execute at 0x%lx OK, return %d\n", buf, ret);

    munmap(buf, sz);
    return 0;
}
