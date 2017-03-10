#ifndef SRC_NODE_CRYPTO_BIO_H_
#define SRC_NODE_CRYPTO_BIO_H_

#if defined(NODE_WANT_INTERNALS) && NODE_WANT_INTERNALS

#include "openssl/bio.h"
#include "env.h"
#include "env-inl.h"
#include "util.h"
#include "util-inl.h"
#include "v8.h"

namespace node {

class NodeBIO {
 public:
  NodeBIO() : env_(nullptr),
              initial_(kInitialBufferLength),
              length_(0),
              eof_return_(-1),
              read_head_(nullptr),
              write_head_(nullptr) {
  }

  ~NodeBIO();

  static BIO* New();

  // NewFixed takes a copy of `len` bytes from `data` and returns a BIO that,
  // when read from, returns those bytes followed by EOF.
  static BIO* NewFixed(const char* data, size_t len);

  void AssignEnvironment(Environment* env);

  // Move read head to next buffer if needed
  void TryMoveReadHead();

  // Allocate new buffer for write if needed
  void TryAllocateForWrite(size_t hint);

  // Read `len` bytes maximum into `out`, return actual number of read bytes
  size_t Read(char* out, size_t size);

  // Memory optimization:
  // Deallocate children of write head's child if they're empty
  void FreeEmpty();

  // Return pointer to internal data and amount of
  // contiguous data available to read
  char* Peek(size_t* size);

  // Return pointers and sizes of multiple internal data chunks available for
  // reading
  size_t PeekMultiple(char** out, size_t* size, size_t* count);

  // Find first appearance of `delim` in buffer or `limit` if `delim`
  // wasn't found.
  size_t IndexOf(char delim, size_t limit);

  // Discard all available data
  void Reset();

  // Put `len` bytes from `data` into buffer
  void Write(const char* data, size_t size);

  // Return pointer to internal data and amount of
  // contiguous data available for future writes
  char* PeekWritable(size_t* size);

  // Commit reserved data
  void Commit(size_t size);


  // Return size of buffer in bytes
  inline size_t Length() const {
    return length_;
  }

  inline void set_eof_return(int num) {
    eof_return_ = num;
  }

  inline int eof_return() {
    return eof_return_;
  }

  inline void set_initial(size_t initial) {
    initial_ = initial;
  }

  static inline NodeBIO* FromBIO(BIO* bio) {
#if OPENSSL_VERSION_NUMBER < 0x10100000L
    CHECK_NE(bio->ptr, nullptr);
    return static_cast<NodeBIO*>(bio->ptr);
#else
    CHECK_NE(BIO_get_data(bio), nullptr);
    return static_cast<NodeBIO*>(BIO_get_data(bio));
#endif
  }

  // Enough to handle the most of the client hellos
  static const size_t kInitialBufferLength = 1024;
  static const size_t kThroughputBufferLength = 16384;

  class Buffer {
   public:
    Buffer(Environment* env, size_t len) : env_(env),
                                           read_pos_(0),
                                           write_pos_(0),
                                           len_(len),
                                           next_(nullptr) {
      data_ = new char[len];
      if (env_ != nullptr)
        env_->isolate()->AdjustAmountOfExternalAllocatedMemory(len);
    }

    ~Buffer() {
      delete[] data_;
      if (env_ != nullptr) {
        const int64_t len = static_cast<int64_t>(len_);
        env_->isolate()->AdjustAmountOfExternalAllocatedMemory(-len);
      }
    }

    Environment* env_;
    size_t read_pos_;
    size_t write_pos_;
    size_t len_;
    Buffer* next_;
    char* data_;
  };

  Environment* env_;
  size_t initial_;
  size_t length_;
  int eof_return_;
  Buffer* read_head_;
  Buffer* write_head_;
};

}  // namespace node

#endif  // defined(NODE_WANT_INTERNALS) && NODE_WANT_INTERNALS

#endif  // SRC_NODE_CRYPTO_BIO_H_
