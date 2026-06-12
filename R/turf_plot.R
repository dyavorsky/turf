turf_plot <- function(results, k = NULL, title = "TURF Reach Curve") {

    max_k <- max(results$rank)
    if (is.null(k)) k <- max_k
    if (k > max_k)
        stop(paste0(
            "k = ", k, " exceeds the ", max_k,
            " bundles retained in results; rerun turf() with a larger keep argument"
        ))

    plot_data <- results[results$rank <= k, ]

    item_cols <- grep("^item", names(plot_data), value = TRUE)
    plot_data$bundle <- apply(
        as.data.frame(plot_data)[, item_cols, drop = FALSE],
        1,
        function(x) paste(x[!is.na(x)], collapse = " + ")
    )

    top1 <- plot_data[plot_data$rank == 1, ]

    ggplot2::ggplot(plot_data, ggplot2::aes(x = factor(size), y = reach * 100)) +
        ggplot2::geom_line(data = top1, ggplot2::aes(group = 1),
                           color = "#0E2841", linewidth = 1) +
        ggplot2::geom_point(ggplot2::aes(alpha = (k - rank + 1) / k),
                            color = "#0E2841", size = 3) +
        ggplot2::geom_point(data = top1, color = "#0E2841", size = 4) +
        ggplot2::geom_label(data = top1, ggplot2::aes(label = bundle),
                            vjust = -0.6, size = 3, label.size = 0,
                            fill = "white", color = "#FA6361") +
        ggplot2::scale_alpha_identity() +
        ggplot2::scale_y_continuous(
            labels = function(x) paste0(x, "%"),
            expand = ggplot2::expansion(mult = c(0.05, 0.2))
        ) +
        ggplot2::labs(x = "Bundle Size", y = "Reach", title = title) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(legend.position = "none",
                       panel.grid.minor = ggplot2::element_blank())
}
