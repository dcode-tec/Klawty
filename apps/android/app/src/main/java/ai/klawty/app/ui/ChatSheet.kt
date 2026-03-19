package ai.klawty.app.ui

import androidx.compose.runtime.Composable
import ai.klawty.app.MainViewModel
import ai.klawty.app.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
