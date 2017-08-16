#include <sstream>

#include "logging.h"

// nICEr includes
extern "C" {
#include "nr_api.h"
#include "ice_ctx.h"
}

// Local includes
#include "nricectxhandler.h"
#include "nricemediastream.h"
#include "nriceresolver.h"

namespace mozilla {

MOZ_MTLOG_MODULE("mtransport")

NrIceCtxHandler::NrIceCtxHandler(const std::string& name,
                                 NrIceCtx::Policy policy)
  : current_ctx(new NrIceCtx(name, policy)),
    old_ctx(nullptr),
    restart_count(0)
{
}

RefPtr<NrIceCtxHandler>
NrIceCtxHandler::Create(const std::string& name,
                        bool allow_loopback,
                        bool tcp_enabled,
                        bool allow_link_local,
                        NrIceCtx::Policy policy)
{
  // InitializeGlobals only executes once
  NrIceCtx::InitializeGlobals(allow_loopback, tcp_enabled, allow_link_local);

  RefPtr<NrIceCtxHandler> ctx = new NrIceCtxHandler(name, policy);

  if (ctx == nullptr ||
      ctx->current_ctx == nullptr ||
      !ctx->current_ctx->Initialize()) {
    return nullptr;
  }

  return ctx;
}


RefPtr<NrIceMediaStream>
NrIceCtxHandler::CreateStream(const std::string& name, int components)
{
  // To make tracking NrIceMediaStreams easier during ICE restart
  // prepend an int to the name that increments with each ICE restart
  std::ostringstream os;
  os << restart_count << "-" << name;
  return NrIceMediaStream::Create(this->current_ctx, os.str(), components);
}


RefPtr<NrIceCtx>
NrIceCtxHandler::CreateCtx() const
{
  return CreateCtx(NrIceCtx::GetNewUfrag(), NrIceCtx::GetNewPwd());
}


RefPtr<NrIceCtx>
NrIceCtxHandler::CreateCtx(const std::string& ufrag,
                           const std::string& pwd) const
{
  RefPtr<NrIceCtx> new_ctx = new NrIceCtx(this->current_ctx->name(),
                                          this->current_ctx->policy());
  if (new_ctx == nullptr) {
    return nullptr;
  }

  if (!new_ctx->Initialize(ufrag, pwd)) {
    return nullptr;
  }

  // copy the stun, and turn servers from the current context
  int r = nr_ice_ctx_set_stun_servers(new_ctx->ctx_,
                                      this->current_ctx->ctx_->stun_servers,
                                      this->current_ctx->ctx_->stun_server_ct);
  if (r) {
    MOZ_MTLOG(ML_ERROR, "Error while setting STUN servers in CreateCtx"
                        << " (likely ice restart related)");
    return nullptr;
  }

  r = nr_ice_ctx_copy_turn_servers(new_ctx->ctx_,
                                   this->current_ctx->ctx_->turn_servers,
                                   this->current_ctx->ctx_->turn_server_ct);
  if (r) {
    MOZ_MTLOG(ML_ERROR, "Error while copying TURN servers in CreateCtx"
                        << " (likely ice restart related)");
    return nullptr;
  }

  // grab the NrIceResolver stashed in the nr_resolver and allocate another
  // for the new ctx.  Note: there may not be an nr_resolver.
  if (this->current_ctx->ctx_->resolver) {
    NrIceResolver* resolver =
      static_cast<NrIceResolver*>(this->current_ctx->ctx_->resolver->obj);
    if (!resolver ||
        NS_FAILED(new_ctx->SetResolver(resolver->AllocateResolver()))) {
      MOZ_MTLOG(ML_ERROR, "Error while setting dns resolver in CreateCtx"
                          << " (likely ice restart related)");
      return nullptr;
    }
  }

  return new_ctx;
}


bool
NrIceCtxHandler::BeginIceRestart(RefPtr<NrIceCtx> new_ctx)
{
  MOZ_ASSERT(!old_ctx, "existing ice restart in progress");
  if (old_ctx) {
    MOZ_MTLOG(ML_ERROR, "Existing ice restart in progress");
    return false; // ice restart already in progress
  }

  if (new_ctx == nullptr) {
    return false;
  }

  ++restart_count;
  old_ctx = current_ctx;
  current_ctx = new_ctx;
  return true;
}


void
NrIceCtxHandler::FinalizeIceRestart()
{
  if (old_ctx) {
    // Fixup the telemetry by transferring old stats to current ctx.
    NrIceStats stats = old_ctx->Destroy();
    current_ctx->AccumulateStats(stats);
  }

  // no harm calling this even if we're not in the middle of restarting
  old_ctx = nullptr;
}


void
NrIceCtxHandler::RollbackIceRestart()
{
  if (old_ctx == nullptr) {
    return;
  }
  current_ctx = old_ctx;
  old_ctx = nullptr;
}

NrIceStats NrIceCtxHandler::Destroy()
{
  NrIceStats stats;

  // designed to be called more than once so if stats are desired, this can be
  // called just prior to the destructor
  if (old_ctx && current_ctx) {
    stats = old_ctx->Destroy();
    current_ctx->AccumulateStats(stats);
  }

  if (current_ctx) {
    stats = current_ctx->Destroy();
  }

  old_ctx = nullptr;
  current_ctx = nullptr;

  return stats;
}

NrIceCtxHandler::~NrIceCtxHandler()
{
  Destroy();
}

} // close namespace
